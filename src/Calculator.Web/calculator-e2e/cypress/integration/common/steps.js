import { Given, When, Then } from "cypress-cucumber-preprocessor/steps";

Given('I open default page', () => {
  const url = Cypress.env('ENV_URL') ?? 'http://localhost/';
  cy.visit(url);
  cy.get('.app', { timeout: 30000 }).should('be.visible');
});

When('I press {string}', (title) => {
  cy.get(`button[aria-label="${title}"]`).click();
})

Then('I see {string}', (title) => {
  cy.get('div.display').should('have.text', title);
})
