-- Create Employees table
CREATE TABLE Employees (
  emp_id NUMBER,
  emp_name VARCHAR2(50),
  emp_department VARCHAR2(50),
  emp_salary NUMBER,
  emp_start_date DATE,
  emp_email VARCHAR2(100),
  emp_phone VARCHAR2(20),
  CONSTRAINT pk_employees PRIMARY KEY (emp_id)
);

-- Insert values into Employees table
INSERT INTO Employees (emp_id, emp_name, emp_department, emp_salary, emp_start_date, emp_email, emp_phone)
VALUES (1, 'John Smith', 'HR', 5000, TO_DATE('2022-01-01', 'YYYY-MM-DD'), 'john@example.com', '123-456-7890');

INSERT INTO Employees (emp_id, emp_name, emp_department, emp_salary, emp_start_date, emp_email, emp_phone)
VALUES (2, 'Jane Doe', 'IT', 6000, TO_DATE('2022-02-01', 'YYYY-MM-DD'), 'jane@example.com', '987-654-3210');

INSERT INTO Employees (emp_id, emp_name, emp_department, emp_salary, emp_start_date, emp_email, emp_phone)
VALUES (3, 'Mike Johnson', 'Sales', 5500, TO_DATE('2022-03-01', 'YYYY-MM-DD'), 'mike@example.com', '456-789-0123');

select * from Employees;

-- Create Projects table
CREATE TABLE Projects (
  project_id NUMBER,
  project_name VARCHAR2(50),
  project_status VARCHAR2(50),
  project_start_date DATE,
  project_end_date DATE,
  CONSTRAINT pk_projects PRIMARY KEY (project_id)
);

-- Insert values into Projects table
INSERT INTO Projects (project_id, project_name, project_status, project_start_date, project_end_date)
VALUES (1, 'Project A', 'In Progress', TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));

INSERT INTO Projects (project_id, project_name, project_status, project_start_date, project_end_date)
VALUES (2, 'Project B', 'Completed', TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-05-31', 'YYYY-MM-DD'));

INSERT INTO Projects (project_id, project_name, project_status, project_start_date, project_end_date)
VALUES (3, 'Project C', 'In Progress', TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-08-31', 'YYYY-MM-DD'));

select * from Projects;

-- Create Assignments table
CREATE TABLE Assignments (
  assignment_id NUMBER,
  emp_id NUMBER,
  project_id NUMBER,
  assignment_start_date DATE,
  assignment_end_date DATE,
  CONSTRAINT pk_assignments PRIMARY KEY (assignment_id),
  CONSTRAINT fk_assignments_employees FOREIGN KEY (emp_id) REFERENCES Employees(emp_id),
  CONSTRAINT fk_assignments_projects FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

-- Insert values into Assignments table
INSERT INTO Assignments (assignment_id, emp_id, project_id, assignment_start_date, assignment_end_date)
VALUES (1, 1, 1, TO_DATE('2022-01-01', 'YYYY-MM-DD'), TO_DATE('2022-04-30', 'YYYY-MM-DD'));

INSERT INTO Assignments (assignment_id, emp_id, project_id, assignment_start_date, assignment_end_date)
VALUES (2, 2, 2, TO_DATE('2022-02-01', 'YYYY-MM-DD'), TO_DATE('2022-05-31', 'YYYY-MM-DD'));

INSERT INTO Assignments (assignment_id, emp_id, project_id, assignment_start_date, assignment_end_date)
VALUES (3, 3, 1, TO_DATE('2022-03-01', 'YYYY-MM-DD'), TO_DATE('2022-06-30', 'YYYY-MM-DD'));

INSERT INTO Assignments (assignment_id, emp_id, project_id, assignment_start_date, assignment_end_date)
VALUES (4, 1, 3, TO_DATE('2022-04-01', 'YYYY-MM-DD'), TO_DATE('2022-09-30', 'YYYY-MM-DD'));

-----------------------------------------------------

SELECT e.emp_id, e.emp_name, e.emp_department, p.project_id, p.project_name, a.assignment_id
FROM Employees e
INNER JOIN Assignments a ON e.emp_id = a.emp_id
INNER JOIN Projects p ON a.project_id = p.project_id;




SELECT e.emp_id, e.emp_name, e.emp_department, p.project_id, p.project_name, a.assignment_id
FROM Employees e
LEFT OUTER JOIN Assignments a ON e.emp_id = a.emp_id
LEFT OUTER JOIN Projects p ON a.project_id = p.project_id;





SELECT e.emp_id, e.emp_name, e.emp_department, p.project_id, p.project_name, a.assignment_id
FROM Employees e
RIGHT OUTER JOIN Assignments a ON e.emp_id = a.emp_id
RIGHT OUTER JOIN Projects p ON a.project_id = p.project_id;




SELECT e.emp_id, e.emp_name, e.emp_department, p.project_id, p.project_name, a.assignment_id
FROM Employees e
FULL OUTER JOIN Assignments a ON e.emp_id = a.emp_id
FULL OUTER JOIN Projects p ON a.project_id = p.project_id;
 -------------------------------------------------------------

SELECT emp_id, emp_name, emp_department, NULL AS project_id, NULL AS project_name, NULL AS assignment_id
FROM Employees
UNION
SELECT NULL AS emp_id, NULL AS emp_name, NULL AS emp_department, project_id, project_name, NULL AS assignment_id
FROM Projects
UNION
SELECT NULL AS emp_id, NULL AS emp_name, NULL AS emp_department, NULL AS project_id, NULL AS project_name, assignment_id
FROM Assignments;


------------------------------------------------------------------

CREATE TYPE Item AS OBJECT (
  item_id NUMBER,
  item_name VARCHAR2(100),
  quantity NUMBER
);

CREATE TYPE ItemList AS TABLE OF Item;

CREATE TABLE Hardware (
  product_id NUMBER,
  product_name VARCHAR2(100),
  items ItemListType
) NESTED TABLE items STORE AS hardware_items;

CREATE TABLE Software (
  product_id NUMBER,
  product_name VARCHAR2(100),
  items ItemListType
) NESTED TABLE items STORE AS software_items;

DECLARE
  v_items ItemListType;
BEGIN
  v_items := ItemListType(ItemType(1, 'Item 1', 10), ItemType(2, 'Item 2', 5));
  INSERT INTO Hardware (product_id, product_name, items)
  VALUES (1, 'Hardware Product A', v_items);

  v_items := ItemListType(ItemType(3, 'Item 3', 8), ItemType(4, 'Item 4', 3), ItemType(5, 'Item 5', 12));
  INSERT INTO Hardware (product_id, product_name, items)
  VALUES (2, 'Hardware Product B', v_items);
END;
/

DECLARE
  v_items ItemListType;
BEGIN
  v_items := ItemListType(ItemType(6, 'Item 6', 15), ItemType(7, 'Item 7', 9));
  INSERT INTO Software (product_id, product_name, items)
  VALUES (1, 'Software Product A', v_items);

  v_items := ItemListType(ItemType(8, 'Item 8', 6), ItemType(9, 'Item 9', 4), ItemType(10, 'Item 10', 20));
  INSERT INTO Software (product_id, product_name, items)
  VALUES (2, 'Software Product B', v_items);
END;
/

SELECT product_id, product_name, item.item_id, item.item_name, item.quantity
FROM Hardware
CROSS JOIN TABLE(Hardware.items) item;


--------------------------------------------------------------------

CREATE TABLE YourTable (
  id NUMBER,
  timestamp_column TIMESTAMP,
  -- Add more columns as needed
);

-- Insert sample data
INSERT INTO YourTable (id, timestamp_column)
VALUES (1, TIMESTAMP '2023-05-15 10:30:00');

INSERT INTO YourTable (id, timestamp_column)
VALUES (2, TIMESTAMP '2023-05-15 12:45:00');

INSERT INTO YourTable (id, timestamp_column)
VALUES (3, TIMESTAMP '2023-05-16 08:15:00');

-- Query using intervals
SELECT *
FROM YourTable
WHERE timestamp_column >= SYSTIMESTAMP - INTERVAL '1' DAY;
-----------------------------------------------------------------------

CREATE TABLE sales (
  department VARCHAR2(50),
  product VARCHAR2(50),
  quantity NUMBER
);
INSERT INTO sales (department, product, quantity)
VALUES ('Department A', 'Product 1', 10);

INSERT INTO sales (department, product, quantity)
VALUES ('Department A', 'Product 2', 15);

INSERT INTO sales (department, product, quantity)
VALUES ('Department B', 'Product 1', 8);

INSERT INTO sales (department, product, quantity)
VALUES ('Department B', 'Product 2', 12);

COMMIT;




SELECT department, product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY ROLLUP(department, product);




SELECT department, product, SUM(quantity) AS total_quantity
FROM sales
GROUP BY CUBE(department, product);



SELECT department, product, SUM(quantity) OVER (PARTITION BY department) AS total_quantity
FROM sales;

