## How to Run This Project

1. **Clone the repository:**

   ```sh
   git clone <repo-url>
   ```

2. **Frontend (Flutter):**

   - Navigate to the frontend directory:
     ```sh
     cd frontend
     ```
   - Run:
     ```sh
     flutter clean
     flutter pub get
     ```
   - Set your local IP address for the backend API in  
     `lib/helpers/api_endpoints.dart`  
     (update the `baseUrl` value).

3. **Backend (Node.js/Express):**

   - Navigate to the backend directory:
     ```sh
     cd ../backend
     ```
   - Install dependencies:
     ```sh
     npm install
     ```
   - Start the backend server:
     ```sh
     npx nodemon index.js
     ```

4. **API Testing:**
   - A Postman collection is included in the repository for easy API testing.  
     Import it into Postman to try out all available endpoints.
