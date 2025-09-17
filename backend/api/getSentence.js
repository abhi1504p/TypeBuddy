const axios = require("axios");
const dotenv = require("dotenv");
dotenv.config();

const API_URL = process.env.API_URL;
const API_KEY = process.env.API_KEY;
const getSentence = async () => {
    try {
        const response = await axios.get(API_URL, {
            headers: {"X-Api-Key": API_KEY},
        });

        if (response.data && response.data.length > 0) {
            const quoteText = response.data[0].quote;
            return quoteText.split(' ');
        } else {
            return ["No", "quote", "found"];
        }
    } catch (error) {
        console.error("❌ Error fetching quote:", error.response?.data || error.message);
        return ["Error", "loading", "quote"];
    }
}

module.exports = getSentence;