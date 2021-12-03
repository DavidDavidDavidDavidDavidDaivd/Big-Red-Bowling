import json
from db import Game, Player, Frame, db
from datetime import datetime, time
from flask import Flask
from flask import request

app = Flask(__name__)
db_filename = "cms.db"

app.config["SQLALCHEMY_DATABASE_URI"] = "sqlite:///%s" % db_filename
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["SQLALCHEMY_ECHO"] = True

# generalized response formats


def success_response(data = None, code=200):
    if data == None:
        return json.dumps({"success": True}) , code

    return json.dumps({"success": True, "data": data}), code


def failure_response(message, code=404):
    return json.dumps({"success": False, "error": message}), code

db.init_app(app)
with app.app_context():
    db.create_all()


# your routes here
@app.route("/api/games/<int:game_id>/", methods=["GET"])
def get_game(game_id):
    game =  Game.query.filter_by(id = game_id).first()
    if game is None:
        return failure_response("gameNotFound", 200)
    #.order_by(Player.score.desc()).all()]
    return success_response(game.rep())


@app.route("/api/players/", methods=["POST"])
def create_player():
    body = json.loads(request.data)
    game_Id = body.get("gameID")
    new_player = Player(name=body.get("name"),game_id = game_Id)
    duplicate_player = Player.query.\
    filter_by(name=body.get("name"), game_id=game_Id).first()
    if not duplicate_player is None:
        return failure_response("duplicatePlayer", 200)
    db.session.add(new_player)
    db.session.commit()
    return success_response(new_player.rep(), 201)

@app.route("/api/games/<int:game_id>/", methods=["DELETE"])
def delete_player(game_id):
    body = json.loads(request.data)
    name = body.get("name")
    game = Game.query.filter_by(id=game_id).first()
    if game is None:
        return failure_response("gameNotFound", 200)
    player = Player.query.\
    filter_by(name=name, game_id=game_id).first()
    if player is None:
        return failure_response("playerNotFound", 200)
    db.session.delete(player)
    db.session.commit()
    return success_response()

"""@app.route("/api/players/<int:player_id>/", methods=["GET"])
def get_player(player_id):
    player = Player.query.filter_by(id=player_id).first()
    if player is None:
        return failure_response("Player not found!")
    return success_response(player.serialize(), 201) """

@app.route("/api/games/delete/<int:game_id>/", methods=["DELETE"])
def cancel_game(game_id):
    game = Game.query.filter_by(id=game_id).first()
    if game is None:
        return failure_response("gameNotFound")
    db.session.delete(game)
    db.session.commit()
    return success_response(game.rep())




@app.route("/api/games/", methods=["POST"])
def create_games():
    body = json.loads(request.data)
    name = body.get("name")
    new_game = Game(name=name)
    db.session.add(new_game)
    db.session.commit()
    return success_response(new_game.serialize(), 201)

def pinlist_to_string(lst):
    s = ""
    if (lst[0]== -1):
        return "-1"
    for i in lst:
        s = s+str(i)

    return s




@app.route("/api/frames/", methods=["POST"])
def post_frame():
    body = json.loads(request.data)
    gameid = body.get("gameID")
    name = body.get("name")
    framename = body.get("frameName")
    firstRoll = body.get("firstRoll")
    secondRoll = body.get("secondRoll")
    thirdRoll = body.get("thirdRoll")
    score = body.get("score")
    mutable = body.get("mutable")
    player = Player.query.\
    filter_by(name=name, game_id=gameid).first()
    player.score= score

    frame = Frame(frame_name =framename, player_id = player.id,
     mutable = mutable, score = score, firstRoll = pinlist_to_string(firstRoll),
      secondRoll = pinlist_to_string(secondRoll), thirdRoll = pinlist_to_string(thirdRoll)
      )
    db.session.add(frame)
    db.session.commit()
    return success_response(frame.serialize(), 201)

"""
@app.route("/api/games/<int:game_id>/", methods=["POST"])
def play_game(game_id):
    game = Game.query.filter_by(id=game_id).first()
    if game is None:
        return failure_response("Game not found")
    body = json.loads(request.data)
    if not "pins" in body or not "roll" in body or not "frame" in body:
        return failure_response("miss information")
    # frame: 0 to 9
    # roll:  0 is first, 1 is second,when frame = 9, roll can be 2
    # pins: 0 to 10
    frame,roll,pins = get_value(body)
    msg = game.validate_values(frame,roll,pins)
    if msg is not None:
       return failure_response(msg)
    game.processPrevFrame(frame, roll, pins)
    if roll == 0:
        new_frame = Frame(
            game_id=game_id,
            frame_num=frame,
            roll1pins=pins,
            frame_score=pins,
            # first ball to check if strike
            strike=(pins == 10 and roll == 0),
            spare=False,
        )
        db.session.add(new_frame)
    else:
        game.updateCurrent(frame, roll, pins)
    db.session.commit()
    game.update((frame == 9 and roll > 0))
    db.session.commit()
    return success_response(game.serialize())"""



if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)
