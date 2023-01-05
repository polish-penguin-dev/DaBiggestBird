#import packages (express refuses to import with ES6 module imports so I'm going to use require instead.
import { Client, GatewayIntentBits, Events, EmbedBuilder, ActivityType } from "discord.js";
import { initializeApp } from "firebase/app";
import { getFirestore, doc, setDoc, getDoc, updateDoc, deleteField } from "firebase/firestore";
import { createRequire } from "module";

require = createRequire(import.meta.url);
express = require "express";
app = express();

app.get "/", (req, res) -> 
  res.send "For UptimeRobot";
 
 app.listen 3000;
  
 firebaseConfig = {
  apiKey: "AIzaSyCi9t6tIXTYTBco2Ar8zGCm1lLhNV_l7Js"
  authDomain: "dabiggestbird-d90d4.firebaseapp.com"
  projectId: "dabiggestbird-d90d4"
  storageBucket: "dabiggestbird-d90d4.appspot.com"
  messagingSenderId: "153746967948"
  appId: "1:153746967948:web:e8a44dac033a01dd309aa9"
  measurementId: "G-03KSC7E4WG"
}

firebaseApp = initializeApp(firebaseConfig);
db = getFirestore(firebaseApp);

client = new Client({ intents:[GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] });

client.on "ready", () ->
  console.log green "The bot is ready!";
  client.user.setPresence({ activities:[{ name: "!help", type: ActivityType.Listening }] });
 
#TODO: Use sets instead.
wormCooldown = [];
weedCooldown = [];
eatCooldown = [];
shitCooldown = [];
kidnapCooldown = [];

#quick note: No need for async, CoffeeScript will infer.
checkUser = (guildId, userId) ->
  docRef = doc(db, "guilds", guildId);
  docSnap = await getDoc(docRef);
  
  if docSnap.data().users[userId] != undefined
    console.log "User is already in the DataBase!";
  else
    console.log "Adding user to the DataBase!";
   
  #to be finished
