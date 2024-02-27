function neuralNetworkApp
    fig = figure('Name', 'Neural Network Approximation', 'Position', [100, 100, 600, 400], 'Color', [0.95, 0.95, 0.95]);

    iSlider = uicontrol('Style', 'slider', 'Min', 1, 'Max', 10, 'Value', 5, 'Units', 'normalized', 'Position', [0.1, 0.75, 0.2, 0.03], 'Callback', @updateValues);
    iLabel = uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [0.1, 0.78, 0.2, 0.03], 'String', 'Difficulty Index i', 'HorizontalAlignment', 'center', 'BackgroundColor', [0.95, 0.95, 0.95]);

    iSlider.SliderStep = [1/(10-1), 1/(10-1)];
    iText = uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [0.1, 0.72, 0.2, 0.03], 'String', sprintf('%.1f', get(iSlider, 'Value')), 'HorizontalAlignment', 'center', 'BackgroundColor', [0.95, 0.95, 0.95]);

    s1Slider = uicontrol('Style', 'slider', 'Min', 1, 'Max', 20, 'Value', 5, 'Units', 'normalized', 'Position', [0.4, 0.75, 0.2, 0.03], 'Callback', @updateValues);
    s1Label = uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [0.4, 0.78, 0.2, 0.03], 'String', 'Hidden Neurons S1', 'HorizontalAlignment', 'center', 'BackgroundColor', [0.95, 0.95, 0.95]);

    s1Slider.SliderStep = [1/(20-1), 1/(20-1)]; 
    s1Text = uicontrol('Style', 'text', 'Units', 'normalized', 'Position', [0.4, 0.72, 0.2, 0.03], 'String', sprintf('%d', round(get(s1Slider, 'Value'))), 'HorizontalAlignment', 'center', 'BackgroundColor', [0.95, 0.95, 0.95]);

    startButton = uicontrol('Style', 'pushbutton', 'String', 'Start Animation', 'Units', 'normalized', 'Position', [0.7, 0.78, 0.2, 0.03], 'Callback', @startAnimation, 'BackgroundColor', [0.3, 0.7, 0.3], 'ForegroundColor', [1, 1, 1]);

    stopButton = uicontrol('Style', 'pushbutton', 'String', 'Stop Animation', 'Units', 'normalized', 'Position', [0.7, 0.72, 0.2, 0.03], 'Callback', @stopAnimation, 'BackgroundColor', [0.7, 0.3, 0.3], 'ForegroundColor', [1, 1, 1]);

    plotAxes = axes('Parent', fig, 'Units', 'normalized', 'Position', [0.1, 0.1, 0.8, 0.5]);

    i = get(iSlider, 'Value');
    S1 = round(get(s1Slider, 'Value'));
    [P, T, P1, T1, net] = initializeNeuralNetwork(i, S1);

    plotData(P1, T1, net, plotAxes);



    function updateValues(~, ~)
        i = get(iSlider, 'Value');
        set(iText, 'String', sprintf('%.1f', i));

        S1 = round(get(s1Slider, 'Value'));
        set(s1Text, 'String', sprintf('%d', S1));

        [P, T, P1, T1, net] = initializeNeuralNetwork(i, S1);
        plotData(P1, T1, net, plotAxes);
    end



    function startAnimation(~, ~)
        global stopAnimationFlag; 
        stopAnimationFlag = false;

        epochsNum = 150;

        for epoch = 1:epochsNum
            [net, ~] = train(net, P, T);
            Y = net(P1);

            plot(plotAxes, P1, T1, '-r', P1, Y, '-b');
            axis(plotAxes, [-2.1, 2.1, -1.5, 2.5]);
            title(plotAxes, ['Epoch: ' num2str(epoch)], 'Color', [0.3, 0.3, 0.3]);
            legend(plotAxes, {'Target', 'Approximation'}, 'Location', 'southeast');
            drawnow;
            pause(0.1);

            if stopAnimationFlag
                break;
            end
        end
    end

   
    function stopAnimation(~, ~)
        global stopAnimationFlag; 
        stopAnimationFlag = true; 
    end
end

function [P, T, P1, T1, net] = initializeNeuralNetwork(i, S1)
    P = -2:(0.4/i):2;
    T = 1 + sin(i*pi*P/4);
    P1 = -2:(0.04/i):2;
    T1 = 1 + sin(i*pi*P1/4);

    net = fitnet(S1);
    net.trainParam.goal = 0.001;
    net.trainParam.show = NaN;
    net.trainParam.epochs = 150; 
    net.trainParam.showWindow = false;
    net = train(net, P, T);
end

function plotData(P1, T1, net, axesHandle)
    Y = net(P1);
    plot(axesHandle, P1, T1, '-r', P1, Y, '-b');
    legend(axesHandle, {'Target', 'Approximation'}, 'Location', 'southwest');
    axis(axesHandle, [-2.1, 2.1, -1.5, 2.5]);
end
