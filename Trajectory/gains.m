controller = 1; %1 = feedback_zd, 2 = feedback_yd

switch controller
    case 1
        k_p1 = 30;
        k_p2 = 30;
        k_d1 = 50;
        k_d2 = 50;
    case 2
        k_p1 = 45;
        k_p2 = 30;
end

