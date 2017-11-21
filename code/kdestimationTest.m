
xi = -0.1:0.01:1.1;
b =  0.015;
    
pdf_TREC_07_grid = kdEstimation(ap_T07{:,:}(:), xi, b);
pdf_TREC_07_original = kdEstimation(ap_TREC_07_1998_AdHoc{:,:}(:), xi, b);

pdf_TREC_08_grid = kdEstimation(ap_T08{:,:}(:), xi, b);
pdf_TREC_08_original = kdEstimation(ap_TREC_08_1999_AdHoc{:,:}(:), xi, b);

pdf_TREC_09_grid = kdEstimation(ap_T09{:,:}(:), xi, b);
pdf_TREC_09_original = kdEstimation(ap_TREC_09_2000_Web{:,:}(:), xi, b);

pdf_TREC_10_grid = kdEstimation(ap_T10{:,:}(:), xi, b);
pdf_TREC_10_original = kdEstimation(ap_TREC_10_2001_Web{:,:}(:), xi, b);

figure
subplot(2,2,1)
    plot(xi, pdf_TREC_07_grid, 'Linewidth', 2);
    hold on
    plot(xi, pdf_TREC_07_original, 'Linewidth', 2);
     xlim([0 1]);
     xlabel('Average Precision');
    legend('TREC 07 Grid', 'TREC 07 Original');
    title('TREC 07')
    
subplot(2,2,2)
    plot(xi, pdf_TREC_08_grid, 'Linewidth', 2);
    hold on
    plot(xi, pdf_TREC_08_original, 'Linewidth', 2);
     xlim([0 1]);
     xlabel('Average Precision');
    legend('TREC 08 Grid', 'TREC 08 Original');
    title('TREC 08')
    
subplot(2,2,3)
    plot(xi, pdf_TREC_09_grid, 'Linewidth', 2);
    hold on
    plot(xi, pdf_TREC_09_original, 'Linewidth', 2);
     xlim([0 1]);
     xlabel('Average Precision');
    legend('TREC 09 Grid', 'TREC 09 Original');
    title('TREC 09')
    
subplot(2,2,4)
    plot(xi, pdf_TREC_10_grid, 'Linewidth', 2);
    hold on
    plot(xi, pdf_TREC_10_original, 'Linewidth', 2);
     xlim([0 1]);
     xlabel('Average Precision');
    legend('TREC 10 Grid', 'TREC 10 Original');
    title('TREC 10')
    