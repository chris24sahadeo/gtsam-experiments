#include <chrono>
#include <filesystem>
#include <fmt/core.h>
#include <opencv2/core.hpp>
#include <opencv2/videoio.hpp>
#include <opencv2/highgui.hpp>
#include <iostream>
#include <vector>

// void SolveBoardPose()

// void DetectBoard(cv::Mat img) {

// }


int main(int, char**) {
  // Webcap cap.
  const int kWidth(1920), kHeight(1080);
  int current_timestamp = std::chrono::duration_cast<std::chrono::seconds>(std::chrono::system_clock::now().time_since_epoch()).count();
  std::filesystem::path save_path = std::filesystem::current_path() / std::filesystem::path("logs") / std::filesystem::path(std::to_string(current_timestamp));
  int img_count = 0;

  cv::VideoCapture cap;
  std::vector<int> camera_params = {
    cv::CAP_PROP_FRAME_WIDTH, kWidth,  // Width.
    cv::CAP_PROP_FRAME_HEIGHT, kHeight,  // Height.
  };
  cap.open(0, cv::CAP_ANY);

  if (!cap.isOpened()) {
    std::cerr << "Failed to open camera." << std::endl;
    return -1;
  }

  cv::Mat frame;
  const std::string kWindowName("Capture");
  cv::namedWindow(kWindowName, cv::WINDOW_NORMAL);
  cv::resizeWindow(kWindowName, kWidth, kHeight);
  while(true){
    cap.read(frame);
    cv::flip(frame, frame, 1);  // Mirror for more natural capture.
    if (frame.empty()) {
      std::cerr << "Empty frame." << std::endl;
      break;
    }
    cv::imshow(kWindowName, frame);


    int key = cv::waitKey(15) & 0xFF;
    if (key == 27) {
      break;
    }
    if (key == 32) {
      if (!std::filesystem::is_directory(save_path)) {
        std::filesystem::create_directories(save_path);
      }
      cv::imwrite(save_path / std::filesystem::path(fmt::format("img_{}", img_count)), frame);
      img_count++;
      std::cerr << "Captured image #" << img_count << std::endl;
    }

  }
  std::cerr << "Done." << std::endl;
  return 0;
}