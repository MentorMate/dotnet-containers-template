using Microsoft.AspNetCore.Mvc;

namespace Arithmetic.Operations.Controllers;

/// <summary>The operations controller.</summary>
[ApiController]
[ApiVersion("1.0")]
[Produces(MediaTypeNames.Application.Json)]
[Route("v{version:apiVersion}")]
public class HomeController : ControllerBase
{
    /// <summary>Subtract two numbers.</summary>
    /// <param name="operands">Input values.</param>
    /// <response code="200">The result of subtraction.</response>
    [HttpPost]
    [Route("subtract")]
    [ProducesResponseType(typeof(Result), StatusCodes.Status200OK)]
    public IActionResult Subtract(Operands operands)
    {
        Console.WriteLine($"Subtracting {operands.OperandTwo} from {operands.OperandOne}");
        var result = decimal.Parse(operands.OperandOne) - decimal.Parse(operands.OperandTwo);
        return Ok(new Result(result));
    }

    /// <summary>Add two numbers.</summary>
    /// <param name="operands">Input values.</param>
    /// <response code="200">The result of addition.</response>
    [HttpPost]
    [Route("add")]
    [ProducesResponseType(typeof(Result), StatusCodes.Status200OK)]
    public IActionResult Add(Operands operands)
    {
        Console.WriteLine($"Add {operands.OperandTwo} and {operands.OperandOne}");
        var result = decimal.Parse(operands.OperandOne) + decimal.Parse(operands.OperandTwo);
        return Ok(new Result(result));
    }
}
