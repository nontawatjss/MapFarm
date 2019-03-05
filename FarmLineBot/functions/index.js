const functions = require('firebase-functions');

const request = require('request-promise');

const admin = require('firebase-admin');

admin.initializeApp(functions.config().firebase);

var db = admin.firestore();


const LINE_MESSAGING_API = 'https://api.line.me/v2/bot/message';
const LINE_HEADER = {
  'Content-Type': 'application/json',
  'Authorization': `Bearer hCNKd/blN3/BIop9SL1rfdl1qhsNBPSg+jwgQnbVADCpxo+Kpa2tGVnpscrzr0PnWvu9+64STHhYfNz+WGfksfJCDkOH3Ah0haiOOlBA4u5bTKtwXwzcp2jQ15MpSJsccG1bTwATlrkrVtL1qI5ErQdB04t89/1O/w1cDnyilFU=`
};



exports.LineBot = functions.https.onRequest((req, res) => {
  if (req.body.events[0].type === 'follow') {
    reply(req.body);
    getUser(res, req.body.events[0].source.userId);
  }if (req.body.events[0].type === 'unfollow') {
    db.collection('users').doc(req.body.events[0].source.userId).delete();
  }if (req.body.events[0].type === 'message') {
    db.collection('users').doc(req.body.events[0].source.userId).delete();
  }

});

exports.GetUserDetail = functions.https.onRequest((req, res) => {
    const userid = `${req.query.userid}`
    return getUser(res, userid);
});

const addUserNew = (id, name, pic) => {
  
  let docRef = db.collection('users').doc(id);
  
  docRef.set({
   userId: id,
   displayName: name,
   pictureUrl: pic
      });
}

// Send to User Id
exports.LineBotPush = functions.https.onRequest((req, res) => {

    const userid = `${req.query.userid}`
    return push(res, userid);
 
});


//get Detail User
const getUser = (res, userid) => {
  return request({
    method: `GET`,
    uri: `https://api.line.me/v2/bot/profile/${userid}`,
    headers: LINE_HEADER,
  }).then((body) => {
    
    var info = JSON.parse(body)
    // do more stuff
    addUserNew(info.userId, info.displayName, info.pictureUrl)

    return res.status(200).send(`Done`);
  }).catch((error) => {
    return Promise.reject(error);
  });
    
}


const push = (res, userid) => {
  return request({
    method: `POST`,
    uri: `${LINE_MESSAGING_API}/push`,
    headers: LINE_HEADER,
    body: JSON.stringify({
      to: userid,
      messages: [
        {
          type: `text`,
          text: `ทอสอบระบบ! แจ้งเตือน: เกิดไฟไหม้ที่ไร่อ้อยแปลง 2 ฝั่งทิศตะวันตก`
        }
      ]
    })
  }).then(() => {
    return res.status(200).send(`Done`);
  }).catch((error) => {
    return Promise.reject(error);
  });
}

const reply = (bodyResponse) => {
  return request({
    method: `POST`,
    uri: `https://api.line.me/v2/bot/message/reply`,
    headers: LINE_HEADER,
    body: JSON.stringify({
      replyToken: bodyResponse.events[0].replyToken,
      messages: [
        {
          type: `text`,
          text: 'user ID ของคุณ' + bodyResponse.events[0].source.userId 
        }
	  ]
    })
  });
};