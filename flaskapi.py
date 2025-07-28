from flask import Flask, request, jsonify
import openai
import json
import requests
import webbrowser
openai.api_key = ""
APIKEY = "" # your marketcheck api key

app = Flask(__name__)

@app.route('/', methods=['POST'])
def respond():
    if not request.is_json:
        return jsonify({"error": "Invalid input. JSON expected."}), 400

    data = request.get_json()
    prompt = data.get('prompt')
    print('-----------------------------------------------------------------------')
    print(prompt)
    if prompt is None:
        return jsonify({"error": "Missing 'prompt'"}), 400

    response_text, image_link,listing_link = getData(prompt)

    response = {
        "gptResponse": response_text,
        "webURL": listing_link,
        "imageURL": image_link
    }

    return jsonify(response), 200


currentNum = 1
def get_car_listing_details(json_data, listing_index):
    try:
        data = json_data
        if listing_index < 1: 
            return "Invalid listing index. Please choose a valid index."
        if listing_index > len(data['listings']):
            listing_index = 1
            with open('num.txt','w') as file:
                file.write('1')
        listing = data['listings'][listing_index - 1]

        car_info = {
            "Make": listing['build'].get('make', 'Not specified'),
            "Model": listing['build'].get('model', 'Not specified'),
            "Year": listing['build'].get('year', 'Not specified'),
            "Trim": listing['build'].get('trim', 'Not specified'),
            "Mileage": listing.get('miles', 'Not specified'),
            "Price": listing.get('price', 'Not specified'),
            "Image": listing['media']['photo_links'][0] if listing['media'].get('photo_links') else "No image available",
            "VDP_URL": listing.get('vdp_url', 'No URL available'),
            "Color": listing.get('base_ext_color', 'No color available'),
            "Inventory": listing.get('inventory_type', 'No info'),
            "Street": listing.get('dealer', {}).get('street', 'No info'),
            "City": listing.get('dealer', {}).get('city', 'No info'),
            "State": listing.get('dealer', {}).get('state', 'No info'),
            "Country": listing.get('dealer', {}).get('country', 'No info'),
            "Zip": listing.get('dealer', {}).get('zip', 'No info'),
            "Drivetrain": listing['build'].get('drivetrain', 'No info'),
            "Fuel": listing['build'].get('fuel_type', 'No info'),
            "Doors": listing['build'].get('doors', 'No info'),
            "mpgcity": listing['build'].get('city_mpg', 'No info'),
            "Seats": listing['build'].get('std_seating', 'No info'),
            "Cylinders": listing['build'].get('cylinders', 'No info'),
            "mpghighway": listing['build'].get('highway_mpg', 'No info'),
            "VIN": listing.get('vin', 'No info'),
            "Phone": listing.get('dealer', {}).get('phone', 'No info'),
            "Interior": listing.get('interior_color', 'No info')
        }


        car_tuple = tuple(car_info.values())


        with open('carinfo.txt', 'w') as file:
            file.write(f'{car_tuple}')

        return car_tuple

    except (KeyError, IndexError, ValueError) as e:
        return f"An error occurred while processing the data: {str(e)}"
    

def getGPTresponse(user_prompt):
    
    messages = [
    {"role": "user", "content": user_prompt}
]


    response = openai.ChatCompletion.create(
    model="gpt-4o",
    messages=messages,
    max_tokens=150,
    temperature=0.7
)
    return response['choices'][0]['message']['content']

def saveContext(answer):
    with open('lastmessage.txt','w') as file:
       file.write(answer)
def getContext():
    with open('lastmessage.txt','r') as file:
        return file.readline().strip()
def getData(promptapi):
    try:
            with open('previousLink.txt', 'r') as file:
                oldlink = file.readline()

            context = ""
            image=""


            user_prompt = (
                f"""
            car_type	string	-	Car condition - used/new	N
            year	integer	-	Manufacturing year of a car	N
            make	string	-	Make of the car	N
            model	string	-	Model of the car	N
            variant	string	-	To filter listing on their variant	N
            model_variant	string	-	To filter listings on their model_variant	N
            country	string	UK	Market country	Y
            plot	boolean	-	Alters the response schema, send a lot more listings with limited fields for plotting	N
            dealer_type	enum	-	Type of dealers to search listings of, Either independent or franchise	N
            nodedup	boolean	-	If nodedup is set to true then API will give results without is_searchable i.e multiple listings for single vin	N
            include_non_vin_listings	boolean	false	Flag to indicate whether to include non vin listings in response or not	Y
            exclude_certified	boolean	-	Flag to exclude / remove certified listings from results	N
            photo_links	boolean	-	A boolean indicating whether to include only those listings that have photo_links in search results	N
            stock_no	string	-	To filter listing on their stock number on dealers lot	N
            exclude_sources	string	-	A list of sources to exclude from result	N
            exclude_dealer_ids	string	-	A list of dealer ids to exclude from result	N
            in_transit	boolean	-	A boolean to filter in transit car	N
            vehicle_registration_mark	string	-	Vehicle Registration Mark	N
            co2_emissions	string	-	CO2 emissions	N
            insurance_group	string	-	Insurance Group	N
            num_owners	int	-	Number of owners	N
            fca_status	string	-	To filter listings on FCA status	N
            vrm	string	-	To filter listings on Vehicle Registration Mark	N
            uvc_id	string	-	To filter listings on uvc id	N
            last_seen_days	integer	-	Fetch listings on when they were last seen on the market	N
            first_seen_days	integer	-	Fetch listings on when they were first seen in the market	N
            ulez_compliant	boolean	false	Fetch listings which are ULEZ compliant	N
            exclude_make	string	-	A list of makes to exclude from result	N
            append_api_key	string	-	To append API key to cached photo links urls	N
            is_vat_included	boolean	-	Fetch listings with/without VAT included in price	N
            radius as int in miles
            zip - needed alongside radius
            city- city to search in
            latitude - float
            longitude - float
            country - listed as USA for usa
            s
            exterior_color - 		
            interior_color - 
            mileage
            miles_range
            title_type - if the car is Clean, Salvage, or rebuilt
                "exterior_color": "Ruby Flare Pearl",
                "interior_color": "Black",
                "base_int_color": "Black",
                "base_ext_color": "Red",
            these are the parameters above.
            State - listed as 2 letter abbreviation of the state. DO NOT PUT THE FULL STATE NAME IN LINK ARGUMENTS! FOR EXAMPLE TX FOR TEXAS. KEEP  STATE AS ABBREVIATION IN THE LINK ARGUMENTS! REMEMBER THIS!
            
            price_range can be used for price range. year_range for year range. miles_range negative means less than certain miles and positive means more than certain miles. to find year_range or price_range less than an amount it is -{amount} and to find more than it is just the amount as the parameter.
            Use radius with a zip or latitude and longitude for finding cars near a specific location. when a zip or city is provided make sure to add radius of 90 miles or a specified range in the prompt. if a state, country or no zip is specified do NOT INCLUDE RADIUS TAG.

            Usually if a color is specified it will be exterior color and NOT interior color. Remember this. for example if a black camry is asked then ensure the exterior is black unless interior color is specified.
            YOU KNOW EVERYTHING ABOUT TOYOTA CARS AND CAN IDENTIFY CONTEXT. FOR EXAMPLE IF ASKED FOR A MINIVAN YOU HAVE THE ABILITY TO CHOOSE A SIENNA.

            XSE, SE, LE, XSE, TRD are some examples of trims. Model examples include camry, corolla, rav4 and highlander. Make examples include toyota and honda.


            Here are the attributes for the api. Using the prompt below return only a link in this format

            https://mc-api.marketcheck.com/v2/search/car/auction/active?api_key={{API_KEY}}&year={{YEAR}}&make={{MAKE}}&model={{MODEL}}&trim={{TRIM}}&include_non_vin_listings=true&nodedup=true&photo_links=true

            Your api key is {APIKEY}

            ONLY RETURN THE LINK. DO NOT RETURN ANY OTHER WORDS. LINK ONLY. If there is any field from the input that is empty, for example if there is no year specifed, then ignore that field in the API call. If there are no new car details mentioned, such as the input saying "show me another car" without any edits to the current car, then return only the word "Next". If the prompt is unrelated, vague, completely bizarre or is not asking for a different car say "No Car Exists" unless it is a question. If the prompt is asking a question about the existing car such as "What is the interior color?" return the word "Question". Also return "Question" if asked a question about where to find the previous car or what dealership the previous car was located at. General questions should come through as "Question" as well and not as "No Car Exists". General unrelated statements or requests should come in as "No Car Exists". MAKE SURE GENERAL CAR QUESTIONS COME AS "No Car Found" unless looking for a specific car or modifications to my request for a car in which case you will provide a LINK!
            Ensure that:
            The endpoint is /car/active unless explicitly mentioned that I want a salvage car
            title_type=clean is included to filter clean-title cars.
            include_non_vin_listings=false excludes incomplete listings.
            photo_links=true ensures results include only listings with photos  
            also ensure that the seller name contains the word toyota if the car is a toyota.

            If asked about leasing make sure you have the credit score and down payment and other things to make a calculation.

            The prompt is below:\n

            """ + promptapi +
            """
            \n
            IF A DIFFERENT MODEL, COLOR, YEAR OR ANY SPECIFICATION SUCH AS TRIM IS MENTIONED THEN USE PREVIOUS LINK CONTEXT and edit the link. An example is "Give me a red color". In that case you will use previous link and edit/add color parameters OR use previous context that will be provided at the end of the prompt depending on which makes more sense.
            For example if asked "Can you make it red please?" or "I want BLANK in this car instead" or if a location is specified. TRY USING OLD LINK IF CONTEXT MAKES SENSE! ONLY USE TOYOTA CARS!  Basically if a new car isnt defined and just additional context is given modify the parameters using the existing link that will be provided soon with old data if the context of your previous response provided at the end of the prompt isnt related more.     - It will refer to the previous car so you will preserve all data about the previous car from the previous link and just change/add a color parameter. here is the previous link.:\n """ + oldlink + " \n\n Using the previous link you can create a new link if you receive a prompt asking for a certain model or color change.  TRY YOUR BEST TO PRESERVE CONTEXT OF THE PREVIOUS LINK IF YOU DO NOT NEED TO MAKE A NEW ONE \n\n If you want context of the the last message you sent in this conversation so far in order to generate a link and the link here is more relavant to the conversation than the previous link passed use the context and current prompt to form a new link, here is some context of your previous response: \n  \n " + getContext() + "\n ONCE AGAIN IF THE CONTEXT OF YOUR LAST RESPONSE THAT WAS ABOVE WAS MORE RELATABLE THAN THE PREVIOUS LINK GENERATE A NEW LINK BASED ON THAT CONTEXT AND THE PROMPT! "
            )
 


            currentresponse = getGPTresponse(user_prompt)
            saveContext(currentresponse)
            print(currentresponse)

                


            
            if(currentresponse!="Next" and currentresponse!="No Car Exists" and currentresponse!="Question"):
                print('link')
                with open('previousLink.txt', 'w') as file:
                    file.write(currentresponse)
                with open('num.txt', 'w') as file1:
                    file1.write('1')
                jsoninfo = requests.get(currentresponse).json()

                if(len(jsoninfo['listings'])==0): raise ValueError('e')

                make, model, year, trim, mileage, price, image, url, color, inventory, street, city, state, country, zip_code, drivetrain, fuel, doors, mpg_city, seats, cylinders, mpg_highway, vin, phone, interior = get_car_listing_details(jsoninfo,1)
                user_prompt = ("Hi! You have to draft a response for the prompt below cause you are a car salesman AI: " + promptapi + f"\n The car chosen is a {make} {model} {trim} from {year} with {mileage} miles for {price} in the color {color}. Depending on the prompt you may need other information such as The inventory type is {inventory}, address is {street},{city},{state},{country},{zip_code}. The drivetrain is {drivetrain} and fuel is {fuel}. There are {doors} doors, {seats} seats,{cylinders} cylinders. City mileage is {mpg_city} and highway is {mpg_highway}. vin is {vin}, phone number for dealer/seller is {phone} and the interior is the color {interior}. You may not need to write the excess information if the prompt doesnt require it. Write a suitable response for the user talking about this car! MAKE IT A SHORT MESSAGE DO NOT TALK TOO MUCH! UNDER 50 WORDS FOR YOUR RESPONSE.")
                answer = getGPTresponse(user_prompt)
                saveContext(answer)
                print(answer)
        
                print(url)
                return answer, image, url 

            elif(currentresponse=="Next"):
                print('next')
                with open('previousLink.txt','r') as file:
                    link = file.readline()
                with open('num.txt','r') as file:
                    chatNumber = int(file.readline())
                jsoninfo = requests.get(link).json()
                if(len(jsoninfo['listings'])==0) : raise ValueError('e')
                chatNumber+=1
                make, model, year, trim, mileage, price, image, url, color, inventory, street, city, state, country, zip_code, drivetrain, fuel, doors, mpg_city, seats, cylinders, mpg_highway, vin, phone, interior = get_car_listing_details(jsoninfo,chatNumber)
                user_prompt = ("Hi! Respond for the prompt below cause a different listing for a car was asked for that the one you initially chose. you can use words like 'here is' or words like 'instead' to show that youre showing a diffrent options but it is the type color and model of car just a different dealership and listing." + promptapi + f"\n The car chosen is a {make} {model} {trim} from {year} with {mileage} miles for {price} in the color {color}. Write a suitable response for the user talking about this car! MAKE IT A SHORT MESSAGE DO NOT TALK TOO MUCH! UNDER 50 WORDS FOR YOUR RESPONSE.")
                answer = getGPTresponse(user_prompt)
                with open('num.txt','w') as file:
                    file.write(str(chatNumber))
                saveContext(answer)
                print(answer)
                print(url)
                return answer, image, url


            elif(currentresponse=="Question"):
                print('q')
                with open('carinfo.txt','r') as file:
                    line = file.readline()
                    make, model, year, trim, mileage, price, image, url, color, inventory, street, city, state, country, zip_code, drivetrain, fuel, doors, mpg_city, seats, cylinders, mpg_highway, vin, phone, interior =eval(line)
                

                user_prompt = (f"""Hi! You are a car finder AI for toyota! Answer this question correctly like you are a toyota employee and answer correctly knowing the context of toyotas inventory! You have been asked a question which may be about the car with the following information: The car chosen is a {make} {model} {trim} from {year} with {mileage} miles for {price} in the color {color}. The inventory type is {inventory}, address is {street},{city},{state},{country},{zip_code}. The drivetrain is {drivetrain} and fuel is {fuel}. There are {doors} doors, {seats} seats,{cylinders} cylinders. City mileage is {mpg_city} and highway is {mpg_highway}. vin is {vin}, phone number for dealer/seller is {phone} and the interior is the color {interior}. Write a suitable response for the user talking about this car! MAKE IT A SHORT MESSAGE DO NOT TALK TOO MUCH! UNDER 50 WORDS FOR YOUR RESPONSE. If you do not know just say you are not sure!
                            
                                YOUR QUESTION WAS: 
                                """ + "\n" + promptapi)
                #print (user_prompt)
                answer = getGPTresponse(user_prompt)
                saveContext(answer)
                print(answer)
                return answer, image, url
            else:
                print('none')
                
                with open('carinfo.txt','r') as file:
                    line = file.readline()
                    make, model, year, trim, mileage, price, image, url, color, inventory, street, city, state, country, zip_code, drivetrain, fuel, doors, mpg_city, seats, cylinders, mpg_highway, vin, phone, interior =eval(line)
                user_prompt = ("You are a car finder AI for toyota! Answer questions about toyota cars. Pretend to be a salesman This prompt being sent to you is a general comment or question! respond normally if it is a random question or comment.  If they were asking more about this car here is the previous car you were talking about but otherwise dont mention this previous car and craft a new response to their query:"  +
                            f"""Hi! You have been asked a question about the car with the following information: The car chosen is a {make} {model} {trim} from {year} with {mileage} miles for {price} in the color {color}. The inventory type is {inventory}, address is {street},{city},{state},{country},{zip_code}. The drivetrain is {drivetrain} and fuel is {fuel}. There are {doors} doors, {seats} seats,{cylinders} cylinders. City mileage is {mpg_city} and highway is {mpg_highway}. vin is {vin}, phone number for dealer/seller is {phone} and the interior is the color {interior}. MAKE IT A SHORT MESSAGE DO NOT TALK TOO MUCH! UNDER 50 WORDS FOR YOUR RESPONSE. If you do not know just say you are not sure!""" +"\nHere is the prompt they gave you:\n " + promptapi + "\n\n ONCE AGAIN YOU ARE A TOYOTA SALESMAN AND HAVE IN DEPTH KNOWLEDGE ABOUT ALL TOYOTA CARS NOT JUST THE PREVIOUSLY SPECIFIED ONE!")
                answer = getGPTresponse(user_prompt)
                saveContext(answer)
                print(answer)
                return answer, "", ""

        
    except Exception as e:
        print(e)
        if(type(e)==ValueError): 
            with open('previousLink.txt','w') as file:
                file.write('')
            return "I'm sorry but no car with those specifications was found in your area. Please try again with different arguments.", "", ""
        else:
            with open('previousLink.txt','w') as file:
                file.write('')
            return "Sorry there was some error! Can you try asking again?", "", ""


if __name__ == '__main__':
 
    app.run(host='0.0.0.0', port=5001, debug=True)
