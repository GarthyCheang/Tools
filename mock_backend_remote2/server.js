var express = require('express');
var app = express();
var expressWs = require('express-ws')(app);
var fs = require("fs");

const resultMapping = {
  "queryGame": "query",
  "deal": "deal",
  "shuffle": "shuffle"
  /* "queryGame": "queryGame",
   "getReels":"getReels",
   "deal": "deal",
   "raise": "raise",
   "fold": "fold"*/
}

app.use(function (req, res, next) {
  console.log('middleware');
  req.testing = 'testing';
  return next();
});

app.get('/', function (req, res, next) {
  console.log('get route', req.testing);
  res.end();
});

app.ws('/ws', function (ws, req) {
  console.log(req.length)
  if (req.length === undefined) {
    ws.send("string");
  }
  ws.on('message', function (msg) {
    /*if (!this.orderList) {
      this._index = 0;
      this.orderList = [];
      this.orderList.push({
        id: "AAA",
        order: ["deal", "end"]
      });
      this.orderList.push({
        id: "BBB",
        order: ["deal", "end"]
      });
    }*/
    if (this.orderList && !this.timer) {
      this.timer = setInterval(function () {
        var result;
        var resultJSON;
        Math.random();
        var randNum = Math.floor(Math.random() * 2);
        switch (this.orderList[this._index].order[0]) {
          case "start": {
            result = JSON.parse(fs.readFileSync('public/startBet.json'));
            result.data.table.id = this.orderList[this._index].id;
            resultJSON = JSON.stringify(result);
            break;
          }
          case "end": {
            result = JSON.parse(fs.readFileSync('public/endBet.json'));
            result.data.table.id = this.orderList[this._index].id;
            resultJSON = JSON.stringify(result);
            break;
          }
          case "deal": {
            if (this.betList && this.betList.length > 0) {
              if (this.betList.includes(this.orderList[this._index].id)) {
                if (this.betList.indexOf(this.orderList[this._index].id) > 0) {
                  this.betList.pop();
                } else {
                  this.betList.shift();
                }
                result = JSON.parse(fs.readFileSync('public/dealWithBet' + randNum.toString() + '.json'));
                result.data.table.id = this.orderList[this._index].id;

              } else {
                result = JSON.parse(fs.readFileSync('public/deal' + randNum.toString() + '.json'));
                result.data.table.id = this.orderList[this._index].id;
              }
            } else {
              result = JSON.parse(fs.readFileSync('public/deal' + randNum.toString() + '.json'));
              result.data.table.id = this.orderList[this._index].id;
            }
            var randIndex = Math.floor(Math.random() * 5);
            var trend = ["TD_BS", "TD_PS", "TD_PP", "TD_CC", "TD_LB"][randIndex];
            if (randIndex < 3) {
              trend += Math.floor(5 + Math.random() * 25).toString();
            }
            result.data.table.handScoreCard.trend = trend;
            resultJSON = JSON.stringify(result);
            break;
          }
        }
        var tmp = this.orderList[this._index].order.shift();
        this.orderList[this._index].order.push(tmp);
        this._index = (++this._index) % 2;
        /*var result = JSON.parse(fs.readFileSync('public/deal.json'));
        var resultJSON = JSON.stringify(result);*/

        if (ws.readyState !== 1) {
          clearInterval(this.timer);
        } else {
          ws.send(resultJSON);
        }
      }.bind(this), 5000 + Math.floor(Math.random() * 5000));
    }
    //console.log("receive message:\n" + msg);
    var request = JSON.parse(msg);
    if (request.action === "queryGame") {
      var result = JSON.parse(fs.readFileSync('public/' + resultMapping[request.action] + ".json"));
      result.requestId = request.requestId;
      var resultJSON = JSON.stringify(result);
      //console.log("send result\n" + resultJSON);
      ws.send(resultJSON);
    } else if (request.action === "joinTable") {
      var result = JSON.parse(fs.readFileSync('public/joinTable.json'));
      result.data.table.id = request.data.table.id;
      result.requestId = request.requestId;
      var resultJSON = JSON.stringify(result);
      ws.send(resultJSON);
      if (!this.orderList) {
        this._index = 0;
        this.orderList = [];
      }
      this.orderList.push({
        id: request.data.table.id,
        order: ["end", "deal"]
      });
    } else if (request.action === "remoteBaccaratBet") {
      if (!this.betList) {
        this.betList = [];
      }
      this.betList.push(request.data.table.id);
      var result = JSON.parse(fs.readFileSync('public/confirmBet.json'));
      result.requestId = request.requestId;
      result.data.table.id = request.data.id;
      var resultJSON = JSON.stringify(result);
      ws.send(resultJSON);
    }

    /*else if (request.type && resultMapping.hasOwnProperty(request.type)) {
      var result = JSON.parse(fs.readFileSync('public/' + resultMapping[request.type] + ".json"));
      var resultJSON = JSON.stringify(result);
      //console.log("send result\n" + resultJSON);
      ws.send(resultJSON);
    } else {
      console.log("unsupported request action")
    }*/
  });
  console.log('socket', req.testing);
});

app.listen(7979);