from typing import Sequence
from flask_sqlalchemy import SQLAlchemy
from datetime import datetime, time
import uuid

db = SQLAlchemy()

# your classes here
class Frame(db.Model):
    __tablename__ = "frame"
    id = db.Column(db.Integer, primary_key=True)
    frame_name = db.Column(db.String,  nullable=False)
    firstRoll = db.Column(db.String, default="-1", nullable=False)
    secondRoll= db.Column(db.String, default="-1", nullable=False)
    thirdRoll = db.Column(db.String, default="-1", nullable=False)
    player_id = db.Column(db.Integer, db.ForeignKey("player.id"), nullable=False)
    mutable = db.Column(db.Boolean, default = True)
    score = db.Column(db.Integer, nullable=False)


    def parsePinStr(self,str):
        lst = []
        if str == "-1" :
            return [-1]
        for i in str:
            lst.append(int(i))

        return lst


    def rep(self):
        return {
                "firstRoll" : self.parsePinStr(self.firstRoll),
                "secondRoll" : self.parsePinStr(self.secondRoll),
                "thirdRoll" : self.parsePinStr(self.thirdRoll),
                "score" : self.score,
                "mutable": self.mutable
        }
    def serialize(self):

        return {
            "firstRoll" : self.parsePinStr(self.firstRoll),
            "secondRoll" : self.parsePinStr(self.secondRoll),
            "thirdRoll" : self.parsePinStr(self.thirdRoll),
            "score" : self.score,
            "mutable": self.mutable
        }


class Player(db.Model):
    __tablename__ = "player"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String, nullable=False)

    game_id = db.Column(db.Integer, db.ForeignKey("game.id"), nullable=False)
    frames = db.relationship("Frame", cascade="delete")
    score = db.Column(db.Integer, default=0, nullable=True)
    def rep(self):
        mydict = {"name": self.name, "score": self.score}
        valdict = {
        "firstRoll": [-1],
        "secondRoll": [-1],
        "thirdRoll": [-1],
        "score": 0,
        "mutable": True
        }
        for i in range(1,11):
            mydict["frame"+ str(i)]=valdict
        return mydict


    def serialize(self):
        valdict = {
        "firstRoll": [-1],
        "secondRoll": [-1],
        "thirdRoll": [-1],
        "score": 0,
        "mutable": True
        }
        mydict = {"name": self.name, "score": self.score}
        index = len(self.frames)
        for f in self.frames:
            mydict[f.frame_name]=f.rep()
        for i in range(index+1,11):
            mydict["frame"+ str(i)] = valdict
        return mydict



class Game(db.Model):
    __tablename__ = "game"
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String)
    players = db.relationship("Player", cascade="delete")
    #start_time = db.Column(db.Integer, default=int(datetime.utcnow().timestamp()))
    #end_time = db.Column(db.Integer, default=int(datetime.utcnow().timestamp()))
    isComplete = db.Column(db.Boolean, default = False)


    def rep(self):
        self.isComplete = True
        for f in self.players:
            if len(f.frames) < 10:
                self.isComplete = False
                break
        return {
           "name":self.name,
            "gameId": self.id,
            "isComplete":self.isComplete,
            "players": [f.serialize() for f in self.players]


        }

    def serialize(self):
        return {
           "name":self.name,

            "gameId": self.id,
            "isComplete":False,
            "players": []

        }
