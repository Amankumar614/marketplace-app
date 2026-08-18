Marketplace App

A Flutter-based marketplace application that allows users to browse listings, filter listings, view listing details, and submit interest in a listing.

Project Overview

The application consists of:

Flutter mobile application
Node.js + Express REST API
MongoDB Atlas database
Render-hosted backend

The Flutter application communicates with the backend using HTTPS REST APIs.

Tech Stack
Frontend
Flutter
Dart
Material UI
HTTP REST API
Backend
Node.js
Express.js
Mongoose
CORS
REST APIs
Database
MongoDB
MongoDB Atlas
Backend Hosting
Render
Features
Listings
Browse marketplace listings
View listing title
View category
View area code
View price
View listing status
View listing details
Filters
Category filter
Area code filter
Minimum price filter
Maximum price filter
Multiple filters together
Reset filters
No-results message
Interest Management
Submit interest for a listing
Interest status starts as Pending
Success message after submitting interest
View submitted interests
View listing title in My Interests
View interest status
Delete all interests
Confirmation before deleting all interests
Application Architecture
Flutter Mobile App
        |
        | HTTPS REST API
        ↓
Node.js + Express
        |
        | Mongoose
        ↓
MongoDB Atlas

The backend is deployed on Render, so the Flutter application can communicate with the backend over the internet.

Production Backend

The backend is hosted on Render.

Production API:

https://marketplace-backend-6yhj.onrender.com

The Flutter application uses:

https://marketplace-backend-6yhj.onrender.com/api
API Endpoints
Listings
GET /api/listings

Returns the available marketplace listings.

Interests
GET /api/interests

Returns submitted interest records.

POST /api/interests

Creates a new interest record.

The newly created interest has:

status: Pending
DELETE /api/interests

Deletes all interest records.

Flutter Setup
Requirements

The following tools are required to run the Flutter application:

Flutter SDK
Dart SDK
Android Studio
Android SDK
Android Emulator or Android device
Clone the Repository
git clone https://github.com/Amankumar614/marketplace-app.git

Enter the project directory:

cd marketplace-app
Install Dependencies
flutter pub get
Run the Application
flutter run

The application requires an internet connection because it communicates with the deployed backend API.

Backend Repository

The backend source code is maintained in a separate GitHub repository.

The backend contains:

Express server
Listing APIs
Interest APIs
MongoDB models
Database seed script
Local Backend Setup

The Flutter application normally uses the deployed Render backend, so running the backend locally is not required for normal testing.

If you want to run the backend locally:

npm install

Create a .env file in the backend directory:

MONGODB_URI=your_mongodb_connection_string
PORT=3000

Start the backend:

node server.js

The local backend will run on:

http://localhost:3000
Database Seeding

The backend contains a seed script for inserting demo listings.

Run:

node seed.js

The seed script inserts the demo marketplace listings.

Note: The seed script resets the listings collection before inserting the demo data. Do not run it against production data.

Security

Sensitive credentials are not included in the repository.

The following files must never be committed:

.env
.env.local

Only .env.example should be included as a configuration template.

Never commit:

MongoDB passwords
API keys
Access tokens
Private credentials
Other sensitive information
Testing

The application has been tested for:

Listing retrieval
Category filtering
Area code filtering
Price filtering
Combined filters
Reset filters
Listing details
Interest submission
Pending interest status
My Interests screen
Delete all interests
MongoDB persistence
Real Android device connectivity
Real Device Testing

The application has been tested on a real Android device.

The Flutter application communicates with the deployed backend through:

HTTPS
   ↓
Render
   ↓
Node.js + Express
   ↓
MongoDB Atlas

Therefore, the reviewer does not need to run the backend locally for normal application testing.

An active internet connection is required.

Project Structure
marketplace-app/
│
├── android/
├── ios/
├── lib/
│   ├── models/
│   ├── screens/
│   ├── services/
│   └── widgets/
│
├── test/
├── pubspec.yaml
├── pubspec.lock
├── .gitignore
└── README.md
Backend Structure
marketplace-backend/
│
├── models/
│   ├── Interest.js
│   └── Listing.js
│
├── routes/
│   ├── interestRoutes.js
│   └── listingRoutes.js
│
├── server.js
├── seed.js
├── package.json
├── package-lock.json
├── .env.example
├── .gitignore
└── README.md
Project Status

The application is currently functional and connected to the deployed backend and MongoDB Atlas database.

Core marketplace functionality has been implemented and tested on a real Android device.