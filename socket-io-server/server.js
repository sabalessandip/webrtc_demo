const http = require('http');
const { Server } = require('socket.io');

const server = http.createServer();
const io = new Server(server);

const clients = {};

io.on('connection', (socket) => {
  const clientId = socket.handshake.query.callerId;

  if (!clientId) {
    console.log('Caller ID is required!');
    socket.disconnect();
    return;
  }

  console.log(`Caller with ID: ${clientId} connected`);

  clients[clientId] = socket;

  socket.on('offer-data', ({ offer, calleeId }) => {
    console.log(`Offer from ${clientId} to ${calleeId}`);

    if (clients[calleeId]) {
      clients[calleeId].emit('offer-data', {
        offer: offer,
        callerId: clientId,
      });
    } else {
      console.log(`Client with ID ${calleeId} not found`);
    }
  });

  socket.on('answer-data', ({ answer, calleeId }) => {
    console.log(`Answer from ${clientId} to ${calleeId}`);

    if (clients[calleeId]) {
      clients[calleeId].emit('answer-data', {
        answer: answer,
        callerId: clientId,
      });
    } else {
      console.log(`Client with ID ${calleeId} not found`);
    }
  });

  socket.on('candidate-data', ({ candidate, calleeId }) => {
    console.log(`Candidate from ${clientId} to ${calleeId}: ${candidate}`);

    if (clients[calleeId]) {
      clients[calleeId].emit('candidate-data', {
        candidate: candidate,
        callerId: clientId,
      });
    } else {
      console.log(`Client with ID ${calleeId} not found`);
    }
  });

  socket.on('disconnect', () => {
    console.log(`Client with ID ${clientId} disconnected`);
    delete clients[clientId];
  });
});

server.listen(3000, () => {
  console.log('Socket.IO server running on port 3000');
});
