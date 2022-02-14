namespace Arithmetic.Operations;

#pragma warning disable MEN008, SA1313

/// <summary>Operation input values.</summary>
public record Operands(string OperandOne, string OperandTwo);

/// <summary>Operation result value.</summary>
public record Result(decimal Value);

#pragma warning restore MEN008, SA1313
