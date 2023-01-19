#import modules
import { createRequire } from "module";
const require = createRequire(import.meta.url);

const express = require("express");
const app = express();
app.set("view engine", "pug");

#setup the webserver

startWeb = (port) ->
  app.get "/", (req, res) ->
    res.render("src/index");
  app.listen(port)
  
export { startWeb };
