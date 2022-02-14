using Arithmetic.Operations;
using Arithmetic.Operations.Controllers;

using FluentAssertions;

using Microsoft.AspNetCore.Mvc;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace Calculator.Services.ArithmeticOperations.Tests
{
    [TestClass]
    public class HomeControllerTests
    {
        [TestMethod]
        public void AddShouldSumTwoNumbers()
        {
            var controller = new HomeController();
            var result = controller.Add(new Operands("3", "5"));
            result
                .Should().BeOfType<OkObjectResult>().Subject
                .Value.Should().BeOfType<Result>().Subject
                .Value.Should().Be(8);
        }

        [TestMethod]
        public void SubtractShouldSubtractTwoNumbers()
        {
            var controller = new HomeController();
            var result = controller.Subtract(new Operands("10", "4"));
            result
                .Should().BeOfType<OkObjectResult>().Subject
                .Value.Should().BeOfType<Result>().Subject
                .Value.Should().Be(6);
        }
    }
}
