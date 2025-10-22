const functions = require('firebase-functions');
const admin = require('firebase-admin');
const stripe = require('stripe')(functions.config().stripe.secret_key);

admin.initializeApp();

// Create Payment Intent
exports.createPaymentIntent = functions.https.onCall(async (data, context) => {
  try {
    const { amount, currency, description } = data;
    
    // Validate input
    if (!amount || !currency || !description) {
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Missing required fields: amount, currency, description'
      );
    }

    // Create payment intent with Stripe
    const paymentIntent = await stripe.paymentIntents.create({
      amount: parseInt(amount) * 100, // Convert to cents
      currency: currency,
      description: description,
      metadata: {
        userId: context.auth ? context.auth.uid : 'anonymous',
        timestamp: new Date().toISOString(),
      },
    });

    return {
      clientSecret: paymentIntent.client_secret,
      paymentIntentId: paymentIntent.id,
    };
  } catch (error) {
    console.error('Error creating payment intent:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to create payment intent: ' + error.message
    );
  }
});

// Confirm Payment and Activate Pro
exports.confirmPayment = functions.https.onCall(async (data, context) => {
  try {
    const { paymentIntentId } = data;
    
    if (!context.auth) {
      throw new functions.https.HttpsError(
        'unauthenticated',
        'User must be authenticated'
      );
    }

    // Retrieve payment intent from Stripe
    const paymentIntent = await stripe.paymentIntents.retrieve(paymentIntentId);
    
    if (paymentIntent.status !== 'succeeded') {
      throw new functions.https.HttpsError(
        'failed-precondition',
        'Payment not completed'
      );
    }

    // Update user's Pro status in Firestore
    const db = admin.firestore();
    const userRef = db.collection('users').doc(context.auth.uid);
    
    await userRef.set({
      isPro: true,
      proActivatedAt: admin.firestore.FieldValue.serverTimestamp(),
      paymentIntentId: paymentIntentId,
      stripeCustomerId: paymentIntent.customer,
      lastUpdated: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    // Log the successful payment
    await db.collection('payments').add({
      userId: context.auth.uid,
      paymentIntentId: paymentIntentId,
      amount: paymentIntent.amount,
      currency: paymentIntent.currency,
      status: 'succeeded',
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    return {
      success: true,
      message: 'Pro account activated successfully',
    };
  } catch (error) {
    console.error('Error confirming payment:', error);
    throw new functions.https.HttpsError(
      'internal',
      'Failed to confirm payment: ' + error.message
    );
  }
});

// Check Pro Status
exports.checkProStatus = functions.https.onCall(async (data, context) => {
  try {
    if (!context.auth) {
      return { isPro: false };
    }

    const db = admin.firestore();
    const userDoc = await db.collection('users').doc(context.auth.uid).get();
    
    if (!userDoc.exists) {
      return { isPro: false };
    }

    const userData = userDoc.data();
    return {
      isPro: userData.isPro || false,
      proActivatedAt: userData.proActivatedAt,
    };
  } catch (error) {
    console.error('Error checking pro status:', error);
    return { isPro: false };
  }
});

// Webhook for Stripe events (optional)
exports.stripeWebhook = functions.https.onRequest(async (req, res) => {
  const sig = req.headers['stripe-signature'];
  let event;

  try {
    event = stripe.webhooks.constructEvent(
      req.body,
      sig,
      functions.config().stripe.webhook_secret
    );
  } catch (err) {
    console.error('Webhook signature verification failed:', err.message);
    return res.status(400).send(`Webhook Error: ${err.message}`);
  }

  // Handle the event
  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object;
      console.log('PaymentIntent succeeded:', paymentIntent.id);
      // Handle successful payment
      break;
    case 'payment_intent.payment_failed':
      const failedPayment = event.data.object;
      console.log('PaymentIntent failed:', failedPayment.id);
      // Handle failed payment
      break;
    default:
      console.log(`Unhandled event type ${event.type}`);
  }

  res.json({ received: true });
});
