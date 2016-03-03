use chatroom

 db.createCollection('messages');

 var peshoGoshoMessages =
     [{
         text: "Hi, what are you up to?",
         date: new Date(ISODate().getTime()),
         isRead: true,
         user: {
             username: "pesho_g",
             fullName: "Pesho Peshev",
             website: "http://www.pesho.com/"
         }
     }, {
         text: "Hi, not much. Just checking out MongoDB.",
         date: new Date(ISODate().getTime() + 1000 * 60 * 1),
         isRead: true,
         user: {
             username: "gosho_g",
             fullName: "Gosho Goshev",
             website: "http://www.gosho.com/"
         }
     }, {
         text: "Oh really, what is this MongoDB new sensatio all aboout?",
         date: new Date(ISODate().getTime() + 1000 * 60 * 2),
         isRead: true,
         user: {
             username: "pesho_g",
             fullName: "Pesho Peshev",
             website: "http://www.pesho.com/"
         }
     }, {
         text: "Well it's a really cool NoSQl DBMS whis stores data in JSON format. It's the new big thing, ypu should chek it out",
         date: new Date(ISODate().getTime() + 1000 * 60 * 1),
         isRead: false,
         user: {
             username: "gosho_g",
             fullName: "Gosho Goshev",
             website: "http://www.gosho.com/"
         }
     }];

 db.messages.insert(peshoGoshoMessages);


 var penkaMinkaMessages =
     [{
         text: "What's up mucka.Did you go to the mall today?There is a 50% off sale on the new GUCCI thongs for redneck crack-heads. You should totaly go get some.",
         date: new Date(ISODate().getTime()),
         isRead: true,
         user: {
             username: "penka_p",
             fullName: "Penka Parahkeva",
             website: "http://www.sexy_mucka.xxx/"
         }
     }, {
         text: "Oh honey, really. I was busy at the plastic surgery clinic all day and couldn't get to the mall. Kiro wants me to look good for his 50th anniversary, so I had to have some botox injections to my butt.",
         date: new Date(ISODate().getTime() + 1000 * 60 * 2),
         isRead: false,
         user: {
             username: "minka_s",
             fullName: "Minka Mazgaldjieva",
             website: "http://www.exotic_minka.xxx/"
         }
     }];

 db.messages.insert(penkaMinkaMessages);


 db.messages.aggregate([{
     $project: {
         _id: 0,
         "user.username": 1,
         text: 1,
         date: {
             $substr: ["$date", 11, 18]
         }
     }
 }]);


 db.messages.find({
     isRead: false
 }, {
     "user.fullName": 1,
     text: 1,
     _id: 0
 });


 db.messages.find({
     $and: [{
         isRead: true
     }, {
         "user.username": {
             $eq: "penka_p"
         }
     }]
 }, {
     text: 1,
     _id: 0
 });


 db.messages.update({
     "user.username": {
         $eq: "pesho_g"
     }
 }, {
     $set: {
         "user.website": "http://peshoG.com"
     }
 }, {
     multi: true
 });


 db.messages.find({
     "user.username": "pesho_g"
 }, {
     "user.website": 1,
     _id: 0
 }).limit(1);


 db.messages.aggregate([{
     $group: {
         _id: "$isRead",
         messages: {
             $sum: 1
         }
     }
 }]);


 cd c: \data
 mongodump --dmob chatroom

 use mydb;
 db.dropDatabase();


 mongorestore -d chatroom
