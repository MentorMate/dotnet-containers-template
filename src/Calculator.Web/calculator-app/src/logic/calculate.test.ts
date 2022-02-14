import { calculate } from './calculate';

describe("calculate", () => {
  test("should set first operand", async () => {
    const state = await calculate({ next: null, operation: null, total: null }, '5');
    expect(state.next).toBe('5');
  });

  test("should set operation", async () => {
    const state = await calculate({ next: null, operation: null, total: '5' }, '-');
    expect(state.total).toBe('5');
    expect(state.operation).toBe('-');
  });
});
