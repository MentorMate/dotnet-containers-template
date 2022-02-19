export interface AppState {
  next: string | null;
  total: string | null;
  operation: string | null;
}

export const emptyState: AppState = {
  total: null,
  next: null,
  operation: null,
};

async function operate(operandOne: string | null, operandTwo: string | null, operationSymbol: string): Promise<string> {
  const operationMap: Record<string, string> = {
    '+': 'add',
    '-': 'subtract'
  };
  const method = operationMap[operationSymbol];
  console.debug(`Calling ${method} service`);
  const rawResponse = await fetch(`api/v1/${method}`, {
    method: 'POST',
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({
      operandOne,
      operandTwo
    }),
  });

  const response = await rawResponse.json();
  return response.value.toString();
}

function isNumber(item: string): boolean {
  return /[0-9]+/.test(item);
}

export async function getState(): Promise<AppState> {
  const rawResponse = await fetch('state');
  const calculatorState = await rawResponse.json();
  return calculatorState;
}

export function saveState(state: AppState): void {
  console.debug(`Persisting State:`, JSON.stringify(state));

  const body = [{
    key: 'calculatorState',
    value: state
  }];

  fetch('state', {
    method: "POST",
    body: JSON.stringify(body),
    headers: {
      "Content-Type": "application/json"
    }
  });
}

/**
 * Given a button name and a calculator data object, return an updated
 * calculator data object.
 *
 * Calculator data object contains:
 *   total:String      the running total
 *   next:String       the next number to be operated on with the total
 *   operation:String  +, -, etc.
 */
export async function calculate(obj: AppState, buttonName: string): Promise<AppState> {
  let result: AppState = { ...obj };
  if (buttonName === "AC") {
    result = emptyState;
  } else if (buttonName === '0' && obj.next === '0') {
  } else if (isNumber(buttonName)) {
    result.next = obj.next === null || obj.next === '0' ? buttonName : (obj.next + buttonName);
    // Clear total if no op.
    if (obj.operation === null) {
      result.total = null;
    }
  } else if (buttonName === '.') {
    if (!obj.next) {
      result.next = '0.';
    } else if (obj.next.includes('.')) {
      // Already have a dot
    } else {
      result.next = obj.next + '.';
    }
  } else if (buttonName === "=") {
    if (obj.next && obj.operation) {
      const total = await operate(obj.total, obj.next, obj.operation);
      result = { ...emptyState, total };
    }
  } else if (obj.next && obj.total && obj.operation) {
    const total = await operate(obj.total, obj.next, obj.operation);
    result = { total, next: null, operation: buttonName };
  } else if (obj.next) {
    result = {
      total: obj.next,
      next: null,
      operation: buttonName,
    };
  } else if (obj.total) {
    result.operation = buttonName;
  }

  return result;
}
