function showsense(sensetype, condition, varargin)

global colorConceptNeuron;
global outlineConceptNeuron;
global viewConceptNeuron;
global syllableConceptNeuron;
global wordConceptNeuron;

if strcmp(sensetype{1}, 'view')
    inputimage=varargin{1};
    showindex=varargin{2};
    figure(8);
    subplot(2,2,1);
    imshow(inputimage);
    hold on;
    title('Fig.1 Current input view');
    subplot(2,2,2);
    plot(ifft(outlineConceptNeuron(viewConceptNeuron(showindex(1)).outline).FD), 'color', ...
        colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(showindex(1)).color(1)).data,0.05,'RGB'),'linewidth',7);
    if condition==2
        title('Fig.2 The view called by current input voice');
    end
    if condition==3
        title('Fig.2 The view concept fired by current input image');
    end
    if condition==4
        UI=varargin{3};
        [UI1,~]=find(UI.viewcallaudition==max(UI.viewcallaudition(:)));
        name=['Fig.2 The view concept fired by current input image and its name is ' ...
            findpronunciation(wordConceptNeuron(UI1(1)).order)];
        title(name);
        subplot(2,2,3);
        [UI2,~]=find(UI.auditioncallview==max(UI.auditioncallview(:)));
        plot(ifft(outlineConceptNeuron(viewConceptNeuron(UI2(1)).outline).FD), 'color', ...
            colorhistogram2RGB(colorConceptNeuron(viewConceptNeuron(UI2(1)).color(1)).data,0.05,'RGB'),'linewidth',7);
        title('Fig.3 The view called by current input voice');
    end
    set(gcf,'position',[30 250 600 400]);
end

if strcmp(sensetype{1}, 'audition')
    
    
end

if strcmp(sensetype{1}, 'taste')
    
    
end

