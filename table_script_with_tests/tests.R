library(testthat)
library(data.table)

source("functions.R")

test_that("output extension", {
	test_input = "bed.1.tsv"
	expected_output = "bed.1.RData"
	actual_output = create_output_path(test_input)
	expect_equal(actual_output, expected_output)
}
)

test_that("empty file handling", {
  test_input = "empty_tb.tsv"
  expected_output = "Input file does not exist or is empty!!"
  expect_message(convert_file(test_input, quit_on_fail=FALSE), expected_output)
}
)

test_that("nonexistent file handling", {
  test_input = "nonsense.tsv"
  expected_output = "Input file does not exist or is empty!!"
  expect_message(convert_file(test_input, quit_on_fail=FALSE), expected_output)
}
)

test_that("normal table handling", {
  test_input = "ok_table.tsv"
  tab <- matrix(c(0, 1, 2, 3, 1, 2, 3, 4, 2, 3, 4, 5, 3, 4, 5, 6), 
                ncol=4, byrow=TRUE)
  colnames(tab) <- c('First', 'Second', 'Third', 'Fourth')
  rownames(tab) <- c(1, 2, 3, 4)
  tab <- data.table(tab)
  output.filename = convert_file(test_input)
  load(output.filename)
  expect_true(all.equal(input.table, tab))
}
)

test_that("table with missing vals handling", {
  test_input = "bad_table.tsv"
  tab <- matrix(c(0, 1, 2, 3, 1, 2, 3, NA, 2, 3, NA, NA, 3, NA, NA, NA), 
                ncol=4, byrow=TRUE)
  colnames(tab) <- c('First', 'Second', 'Third', 'Fourth')
  rownames(tab) <- c(1, 2, 3, 4)
  tab <- data.table(tab)
  output.filename = convert_file(test_input)
  load(output.filename)
  expect_true(all.equal(input.table, tab))
}
)
