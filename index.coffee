#import packages (express refuses to import with ES6 module imports so I'm going to use require instead.
import { Client, GatewayIntentBits, Events, EmbedBuilder, ActivityType } from "discord.js";
import { initializeApp } from "firebase/app";
import { getFirestore, doc, setDoc, getDoc, updateDoc, deleteField } from "firebase/firestore";
import { startWeb } from "./web/index";
startWeb();
  
firebaseConfig = {
  apiKey: "AIzaSyCi9t6tIXTYTBco2Ar8zGCm1lLhNV_l7Js"
  authDomain: "dabiggestbird-d90d4.firebaseapp.com"
  projectId: "dabiggestbird-d90d4"
  storageBucket: "dabiggestbird-d90d4.appspot.com"
  messagingSenderId: "153746967948"
  appId: "1:153746967948:web:e8a44dac033a01dd309aa9"
  measurementId: "G-03KSC7E4WG"
}

firebaseApp = initializeApp firebaseConfig;

db = getFirestore firebaseApp;

client = new Client { intents:[GatewayIntentBits.Guilds, GatewayIntentBits.GuildMessages, GatewayIntentBits.MessageContent] };
embedCl = "#4287f5";

client.on "ready", () ->
  console.log green "The bot is ready!";
  client.user.setPresence { activities:[{ name: "!help", type: ActivityType.Listening }] };

#TODO: Use sets instead.
wormCooldown = [];
weedCooldown = [];
eatCooldown = [];
shitCooldown = [];
kidnapCooldown = [];

#Check if the user is already in the DataBase.
checkUser = (guildId, userId) ->
  docRef = doc db, "guilds", guildId
  docSnap = await getDoc docRef;
  
  if docSnap.data().users[userId] != undefined
    console.log "User is already in the DataBase!";
  else
    console.log "Adding user to the DataBase!";
    template = `{
      "users": {
        "${userId}": {
          "KG": 1,
          "Bird Shit": 0
        }
      }
    }
    `
    await setDoc docRef, JSON.parse(template), { merge:true };

#Check if a users shield has broken - if they bought one from the shop.
checkShield = (guildId, userId, channel) ->
       docRef = doc db, "guilds", guildId;
       docSnap = getDoc docRef;
       shieldHP = docSnap.data().users[userId].inventory.shield.HP;
      if shieldHP <= 0
        newJson = `{
        "users": {
        "${userId}": {
        "inventory": {
        "shield": deleteField()
        }
        }
        }
        }`
        
        await updateDoc docRef, JSON.parse(newJson), { merge:true };
        
        shieldBrokenEmbed = new EmbedBuilder()
        .setColor embedCl
        .setTitle "Oh no! Your shield has broken!"
        .setDescription `<@${userId}>, your shield has been used up!`
        
        channel.send { embeds:[shieldBrokenEmbed] };
      else
        console.log "Shield used up yet!";

client.on Events.MessageCreate, (message) ->
    if message.content.toLowerCase() is "!help"
      helpEmbed = new EmbedBuilder()
      .setColor embedCl
      .setTitle "DaBiggestBird help page."
      .setDescription "A list of commands for the DaBiggestBird bot."
      .addFields(
          {name:"!eat @user || <food>", value:"Eat a bird smaller than you (10 min cooldown, won't work on users with shields) or eat some food (check for complete list by using !eat without any args.)"},
          {name:"!stats || !stats @user", value:"Use with no args to check your stats or mention someone to see theirs."},
          {name:"!poop", value:"-1KG +1 Bird Shit (currency)"},
          {name:"!shit <amount>", value:"Same as poop but lets you specify the amount you want to shit and has a 5 minute cooldown."},
          {name:"!shop", value:"Check whats in the shop!"},
          {name:"!buy <item>", value:"buy something from the shop."},
          {name:"!kidnap @user", value:"1 in 3 chance of kidnapping someone (requires a basement from the store and gives many perks like no cooldowns.)"},
          {name:"!milk @user", value:"Milk someone you have kidnapped - it's worth a lot of money."},
          {name:"!sell <item> <quantity>", value:"Can be used to exchange BS for KG or milk for BS."},
          {name:"!rob @user", value:"Rob someone who doesn't have a shield."}
       )
       .setFooter { text:"Work in progress, bot's code is being re-written." };
       message.channel.send { embeds:[helpEmbed] };
    
     if message.content.toLowerCase().startsWith("!eat")
        item = message.content.slice 5;
        
        if !item
          message.channel.send "please specify a person, or item!";
          return;
        
        if item.startsWith() is "<@" && item.endsWith() is ">"
          if !eatCooldown.includes message.author.id
            eatCooldown.push message.author.id;
            
            delCooldown = () -> 
             eatCooldown = eatCooldown.filter item => item != message.author.id
            setTimeout eatCooldown, 600000;
#To be continued. Note that the full code already exists here (https://replit.com/@polish-penguin-dev/DaBiggestBird#index.js?v=1) but looks super ugly.
