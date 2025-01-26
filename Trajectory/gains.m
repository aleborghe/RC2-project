controller = 2; %1 = feedback_zd, 2 = feedback_yd

switch controller
    case 1
        k_p1 = 110;
        k_p2 = 110;
        k_d1 = 90;
        k_d2 = 90;

    
    case 2
        k_p1 = 45;
        k_p2 = 30;
end

