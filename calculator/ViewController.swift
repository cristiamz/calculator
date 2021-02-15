//
//  ViewController.swift
//  calculator
//
//  Created by Cristian Zuniga on 08/2/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var holder: UIView!
    
    var firstNumber = 0.0
    var secondNumber = 0.0
    var resultNumber = 0.0
    var currentOperation: Operation?
    
    enum Operation{
        case add, substract, multipy, divide, percentage, negative
    }
    
    private var historyLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size:50)
        return label
    }()
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "Helvetica", size:75)
        return label
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNumberPad()
    }
    
    private func setupNumberPad (){
        let buttonSize: CGFloat = view.frame.size.width / 4
        
        
        let zeroButton = UIButton(frame:CGRect(x:0,y: holder.frame.size.height - buttonSize, width: buttonSize*2, height: buttonSize))
        zeroButton.setTitle ("0",for: .normal)
        zeroButton.backgroundColor = .systemTeal
        zeroButton.setTitleColor(.white, for: .normal)
        zeroButton.tag = 1
        zeroButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        holder.addSubview(zeroButton)
        
        let peridoButton = UIButton(frame:CGRect(x:buttonSize * CGFloat(2),y: holder.frame.size.height - buttonSize, width: buttonSize, height: buttonSize))
        peridoButton.setTitle (".",for: .normal)
        peridoButton.backgroundColor = .systemTeal
        peridoButton.setTitleColor(.white, for: .normal)
        peridoButton.tag = 2
        peridoButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        holder.addSubview(peridoButton)
        
        
        for x in 0..<3 {
            let firstRowButton = UIButton(frame:CGRect(x:buttonSize * CGFloat(x) ,y: holder.frame.size.height - (buttonSize * 2), width: buttonSize, height: buttonSize))
            firstRowButton.setTitle ("\(x+1)",for: .normal)
            firstRowButton.backgroundColor = .systemTeal
            firstRowButton.setTitleColor(.white, for: .normal)
            firstRowButton.tag = x + 3
            firstRowButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            holder.addSubview(firstRowButton)
        }
        
        for x in 0..<3 {
            let secondRowButton = UIButton(frame:CGRect(x:buttonSize * CGFloat(x) ,y: holder.frame.size.height - (buttonSize * 3), width: buttonSize, height: buttonSize))
            secondRowButton.setTitle ("\(x+4)",for: .normal)
            secondRowButton.backgroundColor = .systemTeal
            secondRowButton.setTitleColor(.white, for: .normal)
            secondRowButton.tag = x + 6
            secondRowButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            holder.addSubview(secondRowButton)
        }
        
        for x in 0..<3 {
            let thirdRowButton = UIButton(frame:CGRect(x:buttonSize * CGFloat(x) ,y: holder.frame.size.height - (buttonSize * 4), width: buttonSize, height: buttonSize))
            thirdRowButton.setTitle ("\(x+7)",for: .normal)
            thirdRowButton.backgroundColor = .systemTeal
            thirdRowButton.setTitleColor(.white, for: .normal)
            thirdRowButton.tag = x + 9
            thirdRowButton.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
            holder.addSubview(thirdRowButton)
        }

        let operations = ["=","+","-","x","÷"]
        for x in 0..<5 {
            let operationRowButton = UIButton(frame:CGRect(x:buttonSize * CGFloat(3) ,y: holder.frame.size.height - (buttonSize * CGFloat(x+1)), width: buttonSize, height: buttonSize))
            operationRowButton.setTitle (operations[x],for: .normal)
            operationRowButton.backgroundColor = .systemOrange
            operationRowButton.setTitleColor(.white, for: .normal)
            operationRowButton.tag = x+1
            operationRowButton.addTarget(self, action: #selector(operationPressed(_:)), for: .touchUpInside)
            holder.addSubview(operationRowButton)
        }
        
        let operations2 = ["AC","+/-","%"]
        for x in 0..<3 {
            let operationRowButton2 = UIButton(frame:CGRect(x:buttonSize * CGFloat(x) ,y: holder.frame.size.height - (buttonSize * 5), width: buttonSize, height: buttonSize))
            operationRowButton2.setTitle (operations2[x],for: .normal)
            operationRowButton2.backgroundColor = .darkGray
            operationRowButton2.setTitleColor(.white, for: .normal)
            operationRowButton2.tag = x+6
            operationRowButton2.addTarget(self, action: #selector(operationPressed(_:)), for: .touchUpInside)
            holder.addSubview(operationRowButton2)
        }
      
        resultLabel.frame = CGRect(x: 20, y: holder.frame.size.height - (buttonSize * 5) - 110, width: view.frame.size.width-40, height: 100)
        holder.addSubview(resultLabel)

        historyLabel.frame = CGRect(x: 20, y: resultLabel.frame.origin.y - 110, width: view.frame.size.width-40, height: 100)
        holder.addSubview(historyLabel)
        
        

    }
    
    @objc func numberPressed(_ sender: UIButton){
        let tag = sender.tag-1
        let numberTag = sender.tag-2
        
        switch tag {
        case 0:
            if let text = resultLabel.text {
                resultLabel.text = "\(text)\(0)"
            }
        case 1:
            if let text = resultLabel.text, !text.contains("."){
                resultLabel.text = "\(text)."
            }
        default:
           
            if resultLabel.text == "0"{
                resultLabel.text = "\(numberTag)"
            }
            else if let text = resultLabel.text {
                resultLabel.text = "\(text)\(numberTag)"
            }
        }
    }
    
    @objc func operationPressed(_ sender: UIButton){
        let tag = sender.tag
        
        if let text = resultLabel.text, let value = Double(text), firstNumber == 0 {
            firstNumber = value
            resultLabel.text = "0"
        }
        
        switch tag {
        case 1: // =
            if let operation = currentOperation {
               
                if let text = resultLabel.text, let value = Double(text){
                    secondNumber = value
                }
                
                if let historyText = historyLabel.text {
                    historyLabel.text = "\(historyText) \(secondNumber)"
                }
                
                switch operation {
                case .add:
                    let result = firstNumber + secondNumber
                    firstNumber = result
                    secondNumber = 0
                    currentOperation =  nil
                    resultLabel.text = String(format: "%.2f", result)
                    break
                case .substract:
                    let result = firstNumber - secondNumber
                    firstNumber = result
                    secondNumber = 0
                    currentOperation =  nil
                    resultLabel.text = String(format: "%.2f", result)
                    break
                case .multipy:
                    let result = firstNumber * secondNumber
                    firstNumber = result
                    secondNumber = 0
                    currentOperation =  nil
                    resultLabel.text = String(format: "%.2f", result)
                    break
                case .divide:
                    let result = firstNumber / secondNumber
                    firstNumber = result
                    secondNumber = 0
                    currentOperation =  nil
                    resultLabel.text = String(format: "%.2f", result)
                    break
                case .percentage:
                    break
                case .negative:
                    break
                }
                
            }
        case 2: // +
            currentOperation = .add
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) +"
            if  secondNumber == 0 {
                resultLabel.text = "0"
            }
        case 3: // -
            currentOperation = .substract
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) -"
            if  secondNumber == 0 {
                resultLabel.text = "0"
            }
        case 4: //x
            currentOperation = .multipy
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) x"
            if  secondNumber == 0 {
                resultLabel.text = "0"
            }
        case 5: //÷
            currentOperation = .divide
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) /"
            if  secondNumber == 0 {
                resultLabel.text = "0"
            }
        case 6: // AC
            historyLabel.text = ""
            resultLabel.text = "0"
            currentOperation =  nil
            firstNumber = 0
        case 7: // +/-
            secondNumber = -1
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) +/-"
            let result = firstNumber * secondNumber
            firstNumber = result
            secondNumber = 0
            currentOperation =  nil
            resultLabel.text = "\(result)"
        case 8: // %
            secondNumber = 100
            historyLabel.text = "\(String(format: "%.2f", firstNumber)) %"
            let result = firstNumber / secondNumber
            firstNumber = result
            secondNumber = 0
            currentOperation =  nil
            resultLabel.text = String(format: "%.2f", result)
        default:
            break
        }
        
        
    }

}
