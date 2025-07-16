# Expense Tracker Backend API Documentation

## Base URL

```
http://<your-server-ip>:3000/api
```

---

## Authentication

All protected routes require a JWT token in the `Authorization` header:

```
Authorization: Bearer <your_jwt_token>
```

---

## Endpoints

### 1. User Registration

**POST** `/users/register`

**Request Body:**

```json
{
  "name": "John Doe",
  "email": "john@example.com",
  "password": "yourpassword"
}
```

**Response:**

- `201 Created` on success
- `400 Bad Request` if user already exists

---

### 2. User Login

**POST** `/users/login`

**Request Body:**

```json
{
  "email": "john@example.com",
  "password": "yourpassword"
}
```

**Response:**

- `200 OK` with user info and JWT token
- `400 Bad Request` if credentials are invalid

---

### 3. Add Expense

**POST** `/expenses/add`  
**Protected:** Yes

**Headers:**

```
Authorization: Bearer <your_jwt_token>
```

**Request Body:**

```json
{
  "name": "Lunch",
  "amount": 150,
  "date": "2024-07-16T12:00:00.000Z",
  "category": "Food"
}
```

**Response:**

- `201 Created` with the created expense object
- `400 Bad Request` if any field is missing

---

### 4. Get All Expenses

**GET** `/expenses/all`  
**Protected:** Yes

**Headers:**

```
Authorization: Bearer <your_jwt_token>
```

**Response:**

- `200 OK` with an array of expenses for the authenticated user

---

### 5. Delete Expense

**DELETE** `/expenses/delete/:id`  
**Protected:** Yes

**Headers:**

```
Authorization: Bearer <your_jwt_token>
```

**URL Parameter:**

- `id`: The ID of the expense to delete

**Response:**

- `200 OK` if deleted
- `404 Not Found` if the expense does not exist or does not belong to the user

---

## Error Responses

All endpoints may return:

- `500 Internal Server Error` with a message if something goes wrong

---

## Example Usage

### Register

```sh
curl -X POST http://localhost:3000/api/users/register \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com","password":"123456"}'
```

### Login

```sh
curl -X POST http://localhost:3000/api/users/login \
  -H "Content-Type: application/json" \
  -d '{"email":"john@example.com","password":"123456"}'
```

### Add Expense

```sh
curl -X POST http://localhost:3000/api/expenses/add \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <your_jwt_token>" \
  -d '{"name":"Lunch","amount":150,"date":"2024-07-16T12:00:00.000Z","category":"Food"}'
```

### Get All Expenses

```sh
curl -X GET http://localhost:3000/api/expenses/all \
  -H "Authorization: Bearer <your_jwt_token>"
```

### Delete Expense

```sh
curl -X DELETE http://localhost:3000/api/expenses/delete/<expense_id> \
  -H "Authorization: Bearer <your_jwt_token>"
```

---

## Notes

- All dates should be in ISO 8601 format (e.g., `"2024-07-16T12:00:00.000Z"`).
- All expense operations are user-specific and require authentication.
- The API returns JSON responses for all endpoints.

---

\*\*For further testing, a Postman collection is
