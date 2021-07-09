#include <TensorFlowLite.h>
#include <tensorflow/lite/micro/all_ops_resolver.h>
#include <tensorflow/lite/micro/micro_error_reporter.h>
#include <tensorflow/lite/micro/micro_interpreter.h>
#include <tensorflow/lite/schema/schema_generated.h>
#include <tensorflow/lite/version.h>
#include <Arduino_APDS9960.h>
#include "model.h"

namespace {
  const tflite::Model* tf_model = nullptr;
  tflite::ErrorReporter* error_reporter = nullptr;
  tflite::AllOpsResolver resolver;
  tflite::MicroInterpreter* interpreter = nullptr;
  TfLiteTensor* input = nullptr;
  TfLiteTensor* output = nullptr;
  constexpr int arena_size = 8 * 1024;
  byte tensor_arena[arena_size];
}

void setup() {
  Serial.begin(9600);
  while (!Serial) {};
  static tflite::MicroErrorReporter micro_error_reporter;
  error_reporter = &micro_error_reporter;

  if (!APDS.begin()) {
     Serial.println("Error initialize APDS");
  }

  tf_model = tflite::GetModel(model);
  if(tf_model->version() != TFLITE_SCHEMA_VERSION) {
    TF_LITE_REPORT_ERROR(error_reporter,
                         "Model schema mismatch! "
                         "Model provider %d not equal %d",
                         tf_model->version(), TFLITE_SCHEMA_VERSION);
    return;
  }

  interpreter = new tflite::MicroInterpreter(tf_model,resolver,tensor_arena,arena_size, error_reporter);

  interpreter->AllocateTensors();
  input = interpreter->input(0);
  output = interpreter->output(0); 
}

void loop() {
  while (!APDS.colorAvailable() || !APDS.proximityAvailable()) {}

  int r,g,b,a;
  APDS.readColor(r,g,b,a);
  int p = APDS.readProximity();
  float sum = r+g+b;

  if(p==0 && a > 10 && sum > 0) {
    float r_r = r/sum;
    float g_r = g/sum;
    float b_r = b/sum;
    input->data.f[0] = r_r;
    input->data.f[1] = g_r;
    input->data.f[2] = b_r;
    TfLiteStatus invoke_status = interpreter->Invoke();
    if(invoke_status != kTfLiteOk) {
      TF_LITE_REPORT_ERROR(error_reporter, "Invoke failed");
      return;
    }

    int num_classes = 3;

    for (int i =0; i < num_classes; i++) {
      Serial.print(int(output->data.f[i]*100));
      if(i < num_classes-1){
        Serial.print(",");
      }
    }
    Serial.println(); 
    while (!APDS.proximityAvailable() || (APDS.readProximity() == 0)) {}
  }
}
