import Array "mo:base/Array";
import Time "mo:base/Time";

actor CareyPortal {

    public type Property = {
        id : Nat;
        name : Text;
        address : Text;
        rent : Nat;
    };

    public type Maintenance = {
        id : Nat;
        propId : Nat;
        issue : Text;
        status : Text;
        priority : Text;
    };

    // Stable variables live on the blockchain forever
    stable var properties : [Property] = [];
    stable var maintenanceRequests : [Maintenance] = [];
    stable var nextId : Nat = 1;

    // --- Property Methods ---
    public func addProperty(name : Text, addr : Text, rent : Nat) : async Nat {
        let newProp : Property = { id = nextId; name = name; address = addr; rent = rent };
        properties := Array.append<Property>(properties, [newProp]);
        nextId += 1;
        return newProp.id;
    };

    public query func getProperties() : async [Property] {
        return properties;
    };

    // --- Maintenance Methods ---
    public func addRequest(pId : Nat, issue : Text, prio : Text) : async Nat {
        let newReq : Maintenance = { id = nextId; propId = pId; issue = issue; status = "Pending"; priority = prio };
        maintenanceRequests := Array.append<Maintenance>(maintenanceRequests, [newReq]);
        nextId += 1;
        return newReq.id;
    };

    public query func getMaintenance() : async [Maintenance] {
        return maintenanceRequests;
    };
};