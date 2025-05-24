const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendNotification = functions.https.onRequest(async (req, res) => {
    const token = req.body.token;  // Le token de l'appareil cible
    const payload = {
        notification: {
            title: req.body.title,     // Titre de la notification
            body: req.body.body,       // Corps de la notification
        },
    };

    try {
        // Envoyer la notification
        await admin.messaging().sendToDevice(token, payload);
        res.status(200).send('Notification envoyée avec succès');
    } catch (error) {
        console.error('Erreur d\'envoi:', error);
        res.status(500).send('Erreur lors de l\'envoi');
    }
});
