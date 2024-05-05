
-- Table: Category
CREATE TABLE Category (
    category_id INT PRIMARY KEY,
    name VARCHAR(255)
);

-- Table: Auction
CREATE TABLE Auction (
    auction_id INT PRIMARY KEY,
    name VARCHAR(255),
    start_date DATE,
    end_date DATE,
    location VARCHAR(255)
);

-- Table: Item
CREATE TABLE Item (
    item_id INT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT,
    starting_price DECIMAL(10, 2),
    category_id INT,
    CONSTRAINT fk_item_category FOREIGN KEY (category_id) REFERENCES Category(category_id)
);

-- Table: Auction_Item
CREATE TABLE Auction_Item (
    auction_id INT,
    item_id INT,
    PRIMARY KEY (auction_id, item_id),
    CONSTRAINT fk_auction_item_auction FOREIGN KEY (auction_id) REFERENCES Auction(auction_id),
    CONSTRAINT fk_auction_item_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Table: Auction_History
CREATE TABLE Auction_History (
    history_id INT PRIMARY KEY,
    auction_id INT,
    auction_status VARCHAR(255),
    auction_close_date DATE,
    CONSTRAINT fk_auction_history_auction FOREIGN KEY (auction_id) REFERENCES Auction(auction_id)
);

-- Table: Item_Image
CREATE TABLE Item_Image (
    image_id INT PRIMARY KEY,
    item_id INT,
    image_url VARCHAR(255),
    CONSTRAINT fk_item_image_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Table: Bidder
CREATE TABLE Bidder (
    bidder_id INT PRIMARY KEY,
    name VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(20)
);

-- Table: Bid
CREATE TABLE Bid (
    bid_id INT PRIMARY KEY,
    bidder_id INT,
    item_id INT,
    amount DECIMAL(10, 2),
    bid_time DATE,
    CONSTRAINT fk_bid_bidder FOREIGN KEY (bidder_id) REFERENCES Bidder(bidder_id),
    CONSTRAINT fk_bid_item FOREIGN KEY (item_id) REFERENCES Item(item_id)
);

-- Table: Payment
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY,
    bid_id INT,
    payment_amount DECIMAL(10, 2),
    payment_date DATE,
    payment_method VARCHAR(255),
    CONSTRAINT fk_payment_bid FOREIGN KEY (bid_id) REFERENCES Bid(bid_id)
);

-- Table: Bidder_Address
CREATE TABLE Bidder_Address (
    address_id INT PRIMARY KEY,
    bidder_id INT,
    address VARCHAR(255),
    city VARCHAR(255),
    state VARCHAR(255),
    zip_code VARCHAR(10),
    CONSTRAINT fk_bidder_address_bidder FOREIGN KEY (bidder_id) REFERENCES Bidder(bidder_id)
);

-- Add NOT NULL constraints
ALTER TABLE Auction_History
    ALTER COLUMN auction_id SET NOT NULL;

ALTER TABLE Auction
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN start_date SET NOT NULL,
    ALTER COLUMN end_date SET NOT NULL,
    ALTER COLUMN location SET NOT NULL;

ALTER TABLE Auction_Item
    ALTER COLUMN auction_id SET NOT NULL,
    ALTER COLUMN item_id SET NOT NULL;

ALTER TABLE Item
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN starting_price SET NOT NULL,
    ALTER COLUMN category_id SET NOT NULL;

ALTER TABLE Category
    ALTER COLUMN name SET NOT NULL;

ALTER TABLE Item_Image
    ALTER COLUMN item_id SET NOT NULL,
    ALTER COLUMN image_url SET NOT NULL;

ALTER TABLE Bid
    ALTER COLUMN bidder_id SET NOT NULL,
    ALTER COLUMN item_id SET NOT NULL,
    ALTER COLUMN amount SET NOT NULL,
    ALTER COLUMN bid_time SET NOT NULL;

ALTER TABLE Payment
    ALTER COLUMN bid_id SET NOT NULL,
    ALTER COLUMN payment_amount SET NOT NULL,
    ALTER COLUMN payment_date SET NOT NULL,
    ALTER COLUMN payment_method SET NOT NULL;

ALTER TABLE Bidder
    ALTER COLUMN name SET NOT NULL,
    ALTER COLUMN email SET NOT NULL,
    ALTER COLUMN phone SET NOT NULL;

ALTER TABLE Bidder_Address
    ALTER COLUMN bidder_id SET NOT NULL,
    ALTER COLUMN address SET NOT NULL,
    ALTER COLUMN city SET NOT NULL,
    ALTER COLUMN state SET NOT NULL,
    ALTER COLUMN zip_code SET NOT NULL;

-- Adding DEFAULT values and GENERATED ALWAYS AS columns
ALTER TABLE Auction_History
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Auction
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Auction_Item
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Item
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Category
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Item_Image
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Bid
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Payment
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Bidder
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

ALTER TABLE Bidder_Address
    ADD COLUMN record_ts DATE DEFAULT CURRENT_DATE;

-- Date to be inserted, which must be greater than January 1, 2000
ALTER TABLE Auction_History
    ADD CONSTRAINT chk_auction_history_date CHECK (auction_close_date > '2000-01-01');

-- Inserted measured value that cannot be negative
ALTER TABLE Bid
    ADD CONSTRAINT chk_bid_amount CHECK (amount >= 0);

-- Unique constraint
-- Let's assume email in Bidder table should be unique
ALTER TABLE Bidder
    ADD CONSTRAINT unique_bidder_email UNIQUE (email);
