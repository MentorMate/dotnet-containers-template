import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

Given('I open default page', () => {
  const url = Cypress.env('ENV_URL') ?? 'http://localhost/';
  cy.visit(url);
  cy.get('.app', { timeout: 30000 }).should('be.visible');
  cy.intercept({ method: 'POST', url: '/api/v1/*' }).as('apiCall');
  cy.get('button[aria-label=AC').click();
});

When('I press {string}', (title) => {
  cy.get(`button[aria-label="${title.trim()}"]`).click();
});

Then('I see {string}', (title) => {
  cy.wait('@apiCall', { timeout: 2000 });
  cy.get('div.display').should('have.text', title);
});
