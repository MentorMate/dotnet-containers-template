/** @type {import('ts-jest/dist/types').InitialOptionsTsJest} */
module.exports = {
  preset: 'ts-jest',
  globals: {
    'ts-jest': {
      tsconfig: 'tsconfig.test.json',

    },
  },
  testEnvironment: 'jsdom',
  setupFilesAfterEnv: ['<rootDir>/jest-setup.ts'],
  testResultsProcessor: "jest-sonar-reporter",
  coverageDirectory: "../../../TestResults",
  coverageReporters: [
    "text",
    "lcovonly",
    "cobertura"
  ]
};
