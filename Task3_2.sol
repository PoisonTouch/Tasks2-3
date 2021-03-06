
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract Task3_1 {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call
    uint32 public timestamp;

    
    

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

        timestamp = now;
    }

    modifier checkOwnerAccept() {
        require(msg.pubkey()==msg.pubkey(),102);
        tvm.accept();
        _;
    }


    struct task {
        string name;
        uint32 time;
        bool completion;  
    }


    mapping (int8=>task) taskMap;
    int8 public key=0;
    int8[] public numberOpenTasks;// массив ключей открытых задач
    int8[] public numberAllTasks;// массив ключей всех задач
    


    function addTask(string name) public checkOwnerAccept{//добавить задачу
        taskMap[key]=task(name,now,false);
        numberOpenTasks.push(key);
        numberAllTasks.push(key);
        key++;
    }

    function getNumberOpenTasks() public checkOwnerAccept returns (int8)  {//кол-во открытых задач
        int8 number=0;
        for(uint i=0;i<numberOpenTasks.length;i++){
        if(taskMap[numberOpenTasks[i]].completion==false&&taskMap[numberOpenTasks[i]].name!="") number++;
        }
        return number;
    }

    function getTasks() public checkOwnerAccept returns (string[])  {
        string[] Tasks;
        for(uint i=0;i<numberOpenTasks.length;i++){

            if(taskMap[numberOpenTasks[i]].name!="") Tasks.push(taskMap[numberOpenTasks[i]].name);
        }
        return Tasks;
    }

    function getTaskDescription(int8 key1) public checkOwnerAccept returns (string,uint32,bool)  {
        return (taskMap[key1].name,taskMap[key1].time,taskMap[key1].completion);
    }

    function deleteTask(int8 key1) public checkOwnerAccept {
        taskMap[key1].name="";
        taskMap[key1].time=0;
        taskMap[key1].completion=false;
    }

    function markCompletion(int8 key1) public checkOwnerAccept {
        taskMap[key1].completion=true;
        for(uint i=0;i<numberOpenTasks.length;i++)//удаление данной задачи из массива открытых задач
        {
            if(numberOpenTasks[i]==key1)
            {
                for(uint j=i;j<numberOpenTasks.length;j++){
                    numberOpenTasks[j-1]=numberOpenTasks[j];
                }
                numberOpenTasks.pop();
            }
        }
    }


    
}
