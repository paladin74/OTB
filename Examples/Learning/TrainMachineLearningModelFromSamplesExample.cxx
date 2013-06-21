/*=========================================================================

  Program:   ORFEO Toolbox
  Language:  C++
  Date:      $Date$
  Version:   $Revision$


  Copyright (c) Centre National d'Etudes Spatiales. All rights reserved.
  See OTBCopyright.txt for details.


     This software is distributed WITHOUT ANY WARRANTY; without even
     the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
     PURPOSE.  See the above copyright notices for more information.

=========================================================================*/

//Image
#include "otbVectorImage.h"
#include "otbVectorData.h"
#include "otbListSampleGenerator.h"

//Reader
#include "otbImageFileReader.h"
#include "otbVectorDataFileReader.h"

//Estimator
# include "otbSVMMachineLearningModel.h"
#include "otbMachineLearningModelFactory.h"

// Normalize the samples
#include "otbShiftScaleSampleListFilter.h"

// Extract a ROI of the vectordata
#include "otbVectorDataIntoImageProjectionFilter.h"

//  Software Guide : BeginCommandLineArgs
//    INPUTS: {QB_1_ortho.tif}, {VectorData_QB1.shp}
//    OUTPUTS: {clLIBSVMModelQB1.libsvm}
//  Software Guide : EndCommandLineArgs

//  Software Guide : BeginLatex
// This example illustrates the use of the
// \doxygen{otb}{MachineLearningModel} class. This class allows the
// estimation of a classification model (supervised learning) from samples. In this example, we will train an SVM
// with 4 classes.
//
//  Software Guide : EndLatex

int main(int argc, char* argv[])
{

  const char* inputImageFileName = argv[1];
  const char* trainingShpFileName = argv[2];
  const char* outputModelFileName = argv[3];

  typedef unsigned int InputPixelType;
  const unsigned int Dimension = 2;


  typedef otb::VectorImage<InputPixelType,  Dimension> InputImageType;
  typedef otb::Image<InputImageType::InternalPixelType, 2> ImageType;

  typedef otb::VectorData<double, 2>                   VectorDataType;
  
  typedef otb::ImageFileReader<InputImageType>    InputReaderType;
  typedef otb::VectorDataFileReader<VectorDataType> VectorDataReaderType;

// Software Guide : BeginLatex
//
// In this framework, we must transformed the input samples store in a vector
// data into a \subdoxygen{itk}{Statistics}{ListSample} which is the structure
// compatible with the machine learning classes. We are using feature vectors
// for the characterisation of the class and on the other hand the class labels
// are scalar values.  We first re-project the input vector data using the
// \doxygen{otb}{VectorDataIntoImageProjectionFilter} class.  To convert the
// input samples store in a vector data into a
// \subdoxygen{itk}{Statistics}{ListSample}, we use the
// \doxygen{otb}{ListSampleGenerator class}
//
// Software Guide : EndLatex
// VectorData projection filter

// Software Guide : BeginCodeSnippet
  typedef otb::VectorDataIntoImageProjectionFilter<VectorDataType, InputImageType>
                                              VectorDataReprojectionType;

  InputReaderType::Pointer    inputReader = InputReaderType::New();
  inputReader->SetFileName(inputImageFileName);
  
  InputImageType::Pointer image = inputReader->GetOutput();
  image->UpdateOutputInformation();

  // read the Vectordata
  VectorDataReaderType::Pointer vectorReader = VectorDataReaderType::New();
  vectorReader->SetFileName(trainingShpFileName);
  vectorReader->Update();

  VectorDataType::Pointer vectorData = vectorReader->GetOutput();
  vectorData->Update();

  VectorDataReprojectionType::Pointer vdreproj = VectorDataReprojectionType::New();

  vdreproj->SetInputImage(image);
  vdreproj->SetInput(vectorData);
  vdreproj->SetUseOutputSpacingAndOriginFromImage(false);

  vdreproj->Update();

  typedef otb::ListSampleGenerator<InputImageType, VectorDataType> ListSampleGeneratorType;
  ListSampleGeneratorType::Pointer sampleGenerator = ListSampleGeneratorType::New();

  sampleGenerator->SetInput(image);
  sampleGenerator->SetInputVectorData(vdreproj->GetOutput());
  sampleGenerator->SetClassKey("Class");

  sampleGenerator->Update();
  // Software Guide : EndCodeSnippet


  //std::cout << "Number of classes: " << sampleGenerator->GetNumberOfClasses() << std::endl;

  // typedef ListSampleGeneratorType::ListSampleType ListSampleType;
  // typedef otb::Statistics::ShiftScaleSampleListFilter<ListSampleType, ListSampleType> ShiftScaleFilterType;

  // // Shift scale the samples
  // ShiftScaleFilterType::Pointer trainingShiftScaleFilter = ShiftScaleFilterType::New();
  // trainingShiftScaleFilter->SetInput(concatenateTrainingSamples->GetOutput());
  // trainingShiftScaleFilter->SetShifts(meanMeasurementVector);
  // trainingShiftScaleFilter->SetScales(stddevMeasurementVector);
  // trainingShiftScaleFilter->Update();


// Software Guide : BeginLatex
//
// Now, we need to declare the machine learning model which is to be used by the
// classifier. In this case we train a SVM model, the
// \doxygen{otb}{SVMMachineLearningModel} class inherates from the pure virtual
// class \doxygen{otb}{MachineLearningModel} which is templated over the type of
// value used for the measures and the type of pixel used for the labels.  Most
// of the classification and regression algorithms available through this
// interface in OTB is based on the OpenCV library \cite{opencv_library}.  Specific methods
// allow to set classifier parameters. In the case of SVM, we set here the type
// of the kernel. Other parameters are let with their default values.
//
// Software Guide : EndLatex

// Software Guide : BeginCodeSnippet
  typedef otb::SVMMachineLearningModel<InputImageType::InternalPixelType,
                                       ListSampleGeneratorType::ClassLabelType> SVMType;

  SVMType::Pointer SVMClassifier = SVMType::New();

  SVMClassifier->SetInputListSample(sampleGenerator->GetTrainingListSample());
  SVMClassifier->SetTargetListSample(sampleGenerator->GetTrainingListLabel());

  SVMClassifier->SetKernelType(CvSVM::LINEAR);
  // Software Guide : EndCodeSnippet

// Software Guide : BeginLatex
//
// The machine learning interface is generic and give access to We now train the
// SVM model using the \code{Train} and save the model to a text file using the
// \code{Save} method.
//
// Software Guide : EndLatex

// Software Guide : BeginCodeSnippet
  SVMClassifier->Train();
  SVMClassifier->Save(outputModelFileName);
// Software Guide : EndCodeSnippet

// Software Guide : BeginLatex

// You can now use the \code{Predict} method which takes a
// \subdoxygen{itk}{Statistics}{ListSample} as input and estimate the label of the
// input sample using the model. Finallyse the
// \doxygen{otb}{ImageClassificationModel} which inherates from the
// \doxygen{itk}{ImageToImageFilter} and allow to classify pixels in the
// input image and predict their labels using a model.
//
// Software Guide : EndLatex

}
