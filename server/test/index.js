const app = require('../index');
const chai = require('chai');
const { expect } = chai;
chai.use(require('chai-http'));

const request = chai.request(app);

describe('GET /debug', function() {
  it('should render the web console', async function() {
    const response = await request.get('/debug');
    expect(response).to.have.status(200);
    expect(response).to.be.html;
  });
});
