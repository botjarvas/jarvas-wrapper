from flask import Flask, request, jsonify
app = Flask(__name__)
agents = {}
@app.route('/register', methods=['POST'])
def register():
    data = request.json or {}
    agent_id = data.get('agent_id')
    agents[agent_id] = data
    return jsonify({'status':'ok','agent_id':agent_id})

@app.route('/task', methods=['GET'])
def task():
    return jsonify({'task':None})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
