package mypackage

import mypackage2.Bar

import org.scalatest.flatspec.AnyFlatSpec

class TestSuite extends AnyFlatSpec {
  "things" should "work" in {
    assert(Foo.message == "hello world")
  }

  "call lambda test" should "work" in {
    assert(Foo.testLambdas == List(10))
  }

  "plus" should "work" in {
    assert(Bar(1).plus(1) == 2)
  }
}
