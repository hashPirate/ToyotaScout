# ToyotaScout

## Revolutionizing the Car-Buying Experience
ToyotaScout is an AI-powered car sales solution designed to act as your personal virtual salesperson. Built for the Toyota Challenge at TAMUHACK 2025, ToyotaScout transforms the car-buying journey into a seamless and highly personalized experience.

---

### Key Features

#### Personalized Assistance
ToyotaScout leverages state-of-the-art AI to understand your preferences and recommend vehicles tailored to your needs. Its algorithm evaluates car listings based on:
- **Market-Relative Price**: Finds the best value for your budget.
- **Mileage**: Ensures quality and longevity.
- **Year and Features**: Matches you with cars that meet your standards.
- **Context and Parameters**: Remembers all previous context and builds upon that.
- **Advanced Filters**: Additional options like color, drivetrain, and body type.
![image2](https://github.com/user-attachments/assets/11a3d139-11a6-49ef-85a0-7deb0c23365f)
![image3](https://github.com/user-attachments/assets/9518dc0d-f2a0-4a1b-a6d6-25c6a3dcfb84)

#### Location-Based Search
Find cars near you with ease! ToyotaScout uses:
- **Zip Code Filters**: Search for cars within specific areas.
- **GPS Integration**: Automatically identify local listings for your convenience.

#### Context Awareness
ToyotaScout remembers past interactions, ensuring consistent and relevant recommendations over time. No need to repeat yourself – it’s like having a personal assistant who knows you inside and out.

#### Mobile Convenience
Available as a **fully functional mobile app**, ToyotaScout offers a chat-based interface that makes interacting with the chatbot smooth and enjoyable. Carry your virtual salesperson in your pocket!

---

### Architecture Overview
ToyotaScout consists of two primary components:

#### 1. **Flask-Based Backend API**
The backend, built using Flask, powers the AI functionality and serves as the brain behind ToyotaScout. It processes user prompts, analyzes car listings, and returns tailored recommendations.

**Code Snippet for API Interaction:**
```python
import requests

def call_flask_api(prompt):
    url = "https://specialdatathon.ngrok.app"  # Replace with the actual Flask server URL

    payload = {"prompt": prompt}

    try:
        response = requests.post(url, json=payload)

        if response.status_code == 200:
            print("Response from Flask API:")
            print(response.json())
        else:
            print(f"Failed to call API. Status Code: {response.status_code}")
            print("Response:", response.text)

    except requests.exceptions.RequestException as e:
        print(f"An error occurred: {e}")

# Example usage
if __name__ == "__main__":
    user_prompt = input("Enter your prompt: ")
    call_flask_api(user_prompt)
```

#### 2. **Swift-Based Mobile App**
The mobile app is built using Swift and serves as the front-end interface for users. It connects to the Flask API to fetch recommendations and offers a chat-based interaction system.

---

### Getting Started

#### Backend Setup
1. Clone the repository:
   ```bash
   git clone https://github.com/hashPirate/ToyotaScout.git
   cd ToyotaScout
   ```
2. Install the dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Run the Flask server:
   ```bash
     python flaskapi.py
   ```

#### Mobile App Setup
1. Open the Swift project in Xcode.
2. Replace the API endpoint URL in the app’s configuration with your Flask server URL.
3. Build and run the app on your preferred iOS device.

---

### Usage
- Launch the ToyotaScout mobile app.
- Enter your preferences via the chat interface.
- Receive personalized car recommendations instantly.
- IT IS ALWAYS GOOD PRACTICE TO SEND YOU API KEYS THROUGH HEADERS INSTEAD OF IN THE URL. However as the api we used was free and open regardless we decided not to overcomplicate things.

---

### Future Enhancements
- **AR Integration**: Visualize your potential car in 3D.
- **Multilingual Support**: Interact with ToyotaScout in multiple languages.

### Demonstration
- **Youtube**: [YouTube Video](https://youtube.com/shorts/K3nmi0Fl9B0?feature=share)
----

*Experience the future of car shopping with ToyotaScout.*

