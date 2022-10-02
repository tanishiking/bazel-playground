package foo

import org.scalatest.{FlatSpec, MustMatchers}

class FooTest extends FlatSpec with MustMatchers {
  "foo" should "pass" in {
    Foo.foo(1, 2) must be(3)
  }
}
