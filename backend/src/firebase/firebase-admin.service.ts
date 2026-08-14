import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseAdminService {
  private readonly logger = new Logger(FirebaseAdminService.name);

  constructor() {
    if (!admin.apps.length) {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: process.env.FIREBASE_PROJECT_ID,
          privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, '\n'),
          clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
        }),
        storageBucket: `${process.env.FIREBASE_PROJECT_ID}.appspot.com`,
      });
    }
  }

  async verifyIdToken(idToken: string): Promise<admin.auth.DecodedIdToken> {
    try {
      return await admin.auth().verifyIdToken(idToken);
    } catch (error) {
      this.logger.error('Error verifying ID token', error);
      throw error;
    }
  }

  async getUser(uid: string): Promise<admin.auth.UserRecord> {
    try {
      return await admin.auth().getUser(uid);
    } catch (error) {
      this.logger.error('Error getting user', error);
      throw error;
    }
  }

  async sendOtp(phoneNumber: string): Promise<string> {
    try {
      // The Admin SDK does not support signInWithPhoneNumber; return placeholder.
      this.logger.warn('sendOtp is not supported by Firebase Admin SDK. Returning empty verification id.');
      return '';
    } catch (error) {
      this.logger.error('Error sending OTP', error);
      throw error;
    }
  }

  getMessaging() {
    return admin.messaging();
  }

  getStorage() {
    return admin.storage();
  }
}