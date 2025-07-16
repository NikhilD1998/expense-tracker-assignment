# Design Notes: Expense Tracker App

## Architecture Overview

- **Frontend:**  
  Built with **Flutter** for a responsive, cross-platform UI. The app adapts well to different screen sizes and orientations, providing a smooth user experience on both phones and tablets.

- **State Management:**  
  Uses **Riverpod** for robust and scalable state management in Flutter. This ensures that authentication state, expense lists, and UI updates are handled efficiently and reactively.

- **Backend:**  
  Implemented with **Node.js** (Express) for handling API requests and business logic.  
  **MongoDB** is used as the database.

- **Authentication:**  
  User authentication is implemented using **JWT (JSON Web Tokens)**.
  - The backend issues a JWT upon successful login.
  - The Flutter frontend securely stores and attaches the token to API requests for protected routes.

## Unique Features & Reasoning

- **Authentication:**  
  Secure login and session management using JWT ensures only authorized users can access and manage their expenses.

- **Responsive UI:**  
  Flutter’s widget system and layout capabilities are leveraged to create a UI that looks and works great on any device size.

- **State Management with Riverpod:**  
  Riverpod was chosen for its simplicity, testability, and ability to handle complex state scenarios, especially around authentication and dynamic expense lists.

- **Swipe to Delete Expenses:**  
  Users can easily remove expenses from their list with a swipe gesture, providing a familiar and efficient UX pattern.

- **Export to CSV:**  
  Users can export their entire expense list to a `.csv` file, which is saved directly to the Android device's **Downloads** directory.

## Additional Notes

- **Security:**  
  All sensitive operations are protected by JWT authentication.  
  The backend validates tokens for every protected route.

- **Extensibility:**  
  The architecture allows for easy addition of new features, such as analytics, recurring expenses, or cloud sync.

- **Platform Considerations:**
  - The export-to-CSV feature is tailored for Android, writing directly to the Downloads folder for user convenience.

---
