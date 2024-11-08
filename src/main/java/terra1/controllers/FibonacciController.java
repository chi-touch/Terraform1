package terra1.controllers;


import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import terra1.services.Fibonacci;

import java.math.BigInteger;

@RestController
public class FibonacciController {
    @GetMapping("/fibonacci/{n}")

    public BigInteger calculateFibonacci(@PathVariable int n) {
        return Fibonacci.calculateFibonacci(n);
    }
}
