# Node.js Testing Setup Guide

## Testing Stack

- **Unit Tests:** Jest + React Testing Library (for React apps)
- **Integration Tests:** Jest + Supertest
- **E2E Tests:** Playwright
- **Coverage:** Jest coverage + Codecov
- **Quality Gates:** Minimum 80% coverage

## Setup

1. Install dependencies:
```bash
npm install --save-dev jest @testing-library/react @testing-library/jest-dom @testing-library/user-event playwright @playwright/test supertest
```

2. Configure Jest (`jest.config.js`):
```javascript
module.exports = {
  testEnvironment: 'jsdom',
  coverageThreshold: {
    global: {
      branches: 80,
      functions: 80,
      lines: 80,
      statements: 80
    }
  },
  collectCoverageFrom: [
    'src/**/*.{js,jsx}',
    '!src/**/*.stories.{js,jsx}',
    '!src/**/index.{js,jsx}'
  ]
};
```

3. Add test scripts to `package.json`:
```json
{
  "scripts": {
    "test": "jest",
    "test:watch": "jest --watch",
    "test:coverage": "jest --coverage",
    "test:e2e": "playwright test",
    "test:ci": "jest --ci --coverage --maxWorkers=2"
  }
}
```
