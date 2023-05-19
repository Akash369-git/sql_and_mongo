db.createCollection("table1")
db.createCollection("table2")
db.createCollection("table3")

db.table1.insertMany([
  {
    _id: 1,
    field1: "Product A",
    field2: "Category 1"
  },
  {
    _id: 2,
    field1: "Product B",
    field2: "Category 2"
  },
  {
    _id: 3,
    field1: "Product C",
    field2: "Category 1"
  }
])


db.table2.insertMany([
  {
    _id: "Category 1",
    field3: "Department X"
  },
  {
    _id: "Category 2",
    field3: "Department Y"
  },
  {
    _id: "Category 3",
    field3: "Department Z"
  }
])


db.table3.insertMany([
  {
    _id: "Department X",
    field4: "Location 1"
  },
  {
    _id: "Department Y",
    field4: "Location 2"
  },
  {
    _id: "Department Z",
    field4: "Location 3"
  }
])

///////////////////////////////////////////////////////////////////

//---Inner Join-----
db.table1.aggregate([
  {
    $lookup: {
      from: "table2",
      localField: "field2",
      foreignField: "_id",
      as: "join_table2"
    }
  },
  {
    $unwind: "$join_table2"
  },
  {
    $lookup: {
      from: "table3",
      localField: "join_table2.field3",
      foreignField: "_id",
      as: "join_table3"
    }
  },
  {
    $unwind: "$join_table3"
  },
  {
    $project: {
      "table1.field1": 1,
      "join_table2._id": 1,
      "join_table3.field4": 1
    }
  }
])



//-----Left Outer join-------------

db.table1.aggregate([
  {
    $lookup: {
      from: "table2",
      localField: "field2",
      foreignField: "_id",
      as: "join_table2"
    }
  },
  {
    $unwind: {
      path: "$join_table2",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $lookup: {
      from: "table3",
      localField: "join_table2.field3",
      foreignField: "_id",
      as: "join_table3"
    }
  },
  {
    $unwind: {
      path: "$join_table3",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      "table1.field1": 1,
      "join_table2._id": 1,
      "join_table3.field4": 1
    }
  }
])



//---------Right Outer Join-----------

db.table2.aggregate([
  {
    $lookup: {
      from: "table1",
      localField: "_id",
      foreignField: "field2",
      as: "join_table1"
    }
  },
  {
    $unwind: {
      path: "$join_table1",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $lookup: {
      from: "table3",
      localField: "_id",
      foreignField: "join_table1.join_table2.field3",
      as: "join_table3"
    }
  },
  {
    $unwind: {
      path: "$join_table3",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      "join_table1.field1": 1,
      "table2._id": 1,
      "join_table3.field4": 1
    }
  }
])


//----------Full Join--------------

// Left join
const leftJoin = db.table1.aggregate([
  {
    $lookup: {
      from: "table2",
      localField: "field2",
      foreignField: "_id",
      as: "join_table2"
    }
  },
  {
    $unwind: {
      path: "$join_table2",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      "table1.field1": 1,
      "join_table2._id": 1
    }
  }
]);

// Right join
const rightJoin = db.table2.aggregate([
  {
    $lookup: {
      from: "table1",
      localField: "_id",
      foreignField: "field2",
      as: "join_table1"
    }
  },
  {
    $unwind: {
      path: "$join_table1",
      preserveNullAndEmptyArrays: true
    }
  },
  {
    $project: {
      "join_table1.field1": 1,
      "table2._id": 1
    }
  }
]);

// Convert the cursor results to arrays
const leftJoinArray = leftJoin.toArray();
const rightJoinArray = rightJoin.toArray();

// Combine left join and right join results
const fullOuterJoin = [...leftJoinArray, ...rightJoinArray];

// Print the full outer join result
fullOuterJoin.forEach(doc => printjson(doc));

//////////////////////////////////////////////////////////////////////////



db.table1.aggregate([
  {
    $project: {
      _id: 0,
      field: "$field1"
    }
  },
  {
    $facet: {
      union: [
        { $project: { field: 1 } }  // Query on table1
      ],
      union2: [
        { $lookup: { from: "table2", localField: "field", foreignField: "_id", as: "join_table2" } },  // Query on table2
        { $unwind: "$join_table2" },
        { $project: { field: "$join_table2.field2" } }
      ],
      union3: [
        { $lookup: { from: "table3", localField: "field", foreignField: "_id", as: "join_table3" } },  // Query on table3
        { $unwind: "$join_table3" },
        { $project: { field: "$join_table3.field3" } }
      ]
    }
  },
  {
    $project: {
      result: { $setUnion: ["$union.field", "$union2.field", "$union3.field"] }
    }
  }
]);




db.collection.aggregate([
  {
    $group: {
      _id: "$field",
      count: { $sum: 1 }
    }
  },
  {
    $match: {
      count: { $gt: 1 }
    }
  },
  {
    $group: {
      _id: null,
      intersection: { $addToSet: "$_id" }
    }
  },
  {
    $project: {
      _id: 0,
      intersection: { $setIntersection: ["$intersection"] }
    }
  }
]);

////////////////////////////////////////////////////////

db.company.insertOne({
    "name": "XYZ Company",
    "employees": [
      {
        "name": "John Doe",
        "position": "Manager"
      },
      {
        "name": "Jane Smith",
        "position": "Developer"
      },
      {
        "name": "Michael Johnson",
        "position": "Designer"
      }
    ]
  });
  
  
  db.company.find({ "employees.position": "Manager" });

  //////////////////////////////////////////////////////////////////

  //----------------Timestamps-------------------
  const startDate = new Date("2023-01-01T00:00:00Z");
  const endDate = new Date("2023-01-31T23:59:59Z");
  
  const result = db.events.find({
    timestamp: {
      $gte: startDate,
      $lte: endDate
    }
  }).toArray();
  
  printjson(result);
  
  
  //----------------Interval-------------------------
  const intervalHours = 24;
  const intervalMilliseconds = intervalHours * 60 * 60 * 1000;
  
  const startDate = new Date(Date.now() - intervalMilliseconds);
  const endDate = new Date();
  
  db.events.find({
    timestamp: {
      $gte: startDate,
      $lte: endDate
    }
  });
////////////////////////////////////////////////////////////////  


db.sales.aggregate([
    {
      $group: {
        _id: {
          product: "$product",
          category: "$category"
        },
        totalAmount: { $sum: "$amount" }
      }
    }
  ]);
  