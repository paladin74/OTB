otb_module_test()
set(OTBTimeSeriesTests
  otbEnvelopeSavitzkyGolayInterpolationFunctorTest.cxx
  otbPolynomialTimeSeriesTest.cxx
  otbSavitzkyGolayInterpolationFunctorNew.cxx
  otbSavitzkyGolayInterpolationFunctorTest.cxx
  otbTimeSeriesLeastSquareFittingFunctorNew.cxx
  otbTimeSeriesLeastSquareFittingFunctorTest.cxx
  otbTimeSeriesLeastSquareFittingFunctorWeightsTest.cxx
  otbTimeSeriesTestDriver.cxx  )

add_executable(otbTimeSeriesTestDriver ${OTBTimeSeriesTests})
target_link_libraries(otbTimeSeriesTestDriver ${OTBTimeSeries-Test_LIBRARIES})
otb_module_target_label(otbTimeSeriesTestDriver)
otb_add_test(NAME mtTvEnvelopeSavitzkyGolayInterpolationFunctorTest COMMAND otbTimeSeriesTestDriver
  otbEnvelopeSavitzkyGolayInterpolationFunctorTest
  )
otb_add_test(NAME mtTvPolynomialTimeSeriesTest1 COMMAND otbTimeSeriesTestDriver
  otbPolynomialTimeSeriesTest
  )
otb_add_test(NAME mtTuSavitzkyGolayInterpolationFunctor COMMAND otbTimeSeriesTestDriver
  otbSavitzkyGolayInterpolationFunctorNew
  )
otb_add_test(NAME mtTvSavitzkyGolayInterpolationFunctorTest COMMAND otbTimeSeriesTestDriver
  otbSavitzkyGolayInterpolationFunctorTest
  )
otb_add_test(NAME mtTuTimeSeriesLeastSquaresFittingFunctor COMMAND otbTimeSeriesTestDriver
  otbTimeSeriesLeastSquareFittingFunctorNew
  )
otb_add_test(NAME mtTvTimeSeriesLeastSquaresFittingFunctor2 COMMAND otbTimeSeriesTestDriver
  otbTimeSeriesLeastSquareFittingFunctorTest
  10 0.3 3.123
  )
otb_add_test(NAME mtTvTimeSeriesLeastSquaresFittingFunctor COMMAND otbTimeSeriesTestDriver
  otbTimeSeriesLeastSquareFittingFunctorTest
  1 2 3
  )
otb_add_test(NAME mtTvTimeSeriesLeastSquaresFittingFunctorWeights COMMAND otbTimeSeriesTestDriver
  otbTimeSeriesLeastSquareFittingFunctorWeightsTest
  1 2 3
  )
