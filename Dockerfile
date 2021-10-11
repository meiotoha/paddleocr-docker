FROM registry.baidubce.com/paddlepaddle/paddle:latest-dev

RUN pip3 install --upgrade pip -i https://mirror.baidu.com/pypi/simple

RUN pip3 install paddlepaddle==2.0.0 -i https://mirror.baidu.com/pypi/simple

RUN pip3 install paddle-serving-server==0.6.3 -i https://mirror.baidu.com/pypi/simple

RUN pip3 install paddle-serving-client==0.6.3 -i https://mirror.baidu.com/pypi/simple

RUN pip3 install paddle-serving-app==0.6.3 -i https://mirror.baidu.com/pypi/simple

RUN git clone https://gitee.com/paddlepaddle/PaddleOCR /PaddleOCR

WORKDIR /PaddleOCR/deploy/pdserving/

RUN wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_det_infer.tar && tar xf ch_ppocr_mobile_v2.0_det_infer.tar

RUN wget https://paddleocr.bj.bcebos.com/dygraph_v2.0/ch/ch_ppocr_mobile_v2.0_rec_infer.tar && tar xf ch_ppocr_mobile_v2.0_rec_infer.tar

RUN python3 -m paddle_serving_client.convert --dirname ./ch_ppocr_mobile_v2.0_det_infer/ \
                                         --model_filename inference.pdmodel          \
                                         --params_filename inference.pdiparams       \
                                         --serving_server ./ppocr_det_mobile_2.0_serving/ \
                                         --serving_client ./ppocr_det_mobile_2.0_client/

RUN python3 -m paddle_serving_client.convert --dirname ./ch_ppocr_mobile_v2.0_rec_infer/ \
                                         --model_filename inference.pdmodel          \
                                         --params_filename inference.pdiparams       \
                                         --serving_server ./ppocr_rec_mobile_2.0_serving/  \
                                         --serving_client ./ppocr_rec_mobile_2.0_client/
EXPOSE 9998

CMD ["/bin/bash","-c","python3 /PaddleOCR/deploy/pdserving/web_service.py"]                        