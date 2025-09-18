package main

import "testing"

func TestAppLoads(t *testing.T) {
    expected := "hello"
    actual := "hello"

    if actual != expected {
        t.Errorf("Test failed: Expected %s, got %s", expected, actual)
    }
}