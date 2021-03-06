workflow arrays {

  Array[Int] vanilla_array
  Array[Int]? optional_array
  Array[Int?] array_of_optionals
  Array[Int?]? optional_array_of_optionals
  Pair[Int, String] pair
  Pair[Pair[Int, Int], String] nested_pair
  Array[Int] default_array = [1, 2,     4, 8] # checking that we're doing something nicer than printing the string - result has no spaces

  output {
    Array[Int] output_vanilla_array = []
    Array[Int]? output_optional_array = []
    Array[Int?] output_array_of_optionals = []
    Array[Int?]? output_optional_array_of_optionals = []
    Pair[Int, String] output_pair = (4, "asdf")
    Pair[Pair[Int, Int], String] output_nested_pair = ((5, 4), "asdf")
  }

}
