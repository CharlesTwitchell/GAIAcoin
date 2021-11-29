# PyChain Ledger
################################################################################


################################################################################
# Imports
import streamlit as st
from dataclasses import dataclass
from typing import Any, List
import datetime as datetime
import pandas as pd
import hashlib
from PIL import Image
import plotly.express as px
from plotly.subplots import make_subplots
import plotly.graph_objects as go
################################################################################


# @TODO
# Create a Record Data Class that consists of the `sender`, `receiver`, and
# `amount` attributes

@dataclass
class Record:
    sender: str
    receiver: str
    amount: float
################################################################################



@dataclass
class Block:

    # @TODO
    # Rename the `data` attribute to `record`, and set the data type to `Record`
    # data: Any
    record: Record

    creator_id: int
    prev_hash: str = "0"
    timestamp: str = datetime.datetime.utcnow().strftime("%H:%M:%S")
    nonce: int = 0

    def hash_block(self):
        sha = hashlib.sha256()

        record = str(self.record).encode()
        sha.update(record)

        creator_id = str(self.creator_id).encode()
        sha.update(creator_id)

        timestamp = str(self.timestamp).encode()
        sha.update(timestamp)

        prev_hash = str(self.prev_hash).encode()
        sha.update(prev_hash)

        nonce = str(self.nonce).encode()
        sha.update(nonce)

        return sha.hexdigest()


@dataclass
class PyChain:
    chain: List[Block]
    difficulty: int = 4

    def proof_of_work(self, block):

        calculated_hash = block.hash_block()

        num_of_zeros = "0" * self.difficulty

        while not calculated_hash.startswith(num_of_zeros):

            block.nonce += 1

            calculated_hash = block.hash_block()

        print("Wining Hash", calculated_hash)
        return block

    def add_block(self, candidate_block):
        block = self.proof_of_work(candidate_block)
        self.chain += [block]

    def is_valid(self):
        block_hash = self.chain[0].hash_block()

        for block in self.chain[1:]:
            if block_hash != block.prev_hash:
                print("Blockchain is invalid!")
                return False

            block_hash = block.hash_block()

        print("Blockchain is Valid")
        return True

################################################################################
# Streamlit Code

# Adds the cache decorator for Streamlit


@st.cache(allow_output_mutation=True)
def setup():
    print("Initializing Chain")
    return PyChain([Block("Genesis", 0)])

logo = Image.open("logo_size_invert.jpg")
st.image(logo)
st.markdown('<style>body{background-color: Green;}</style>',unsafe_allow_html=True)
st.markdown("# GAIA Coin")
st.markdown("## Get Paid to Impact the World")

pychain = setup()

################################################################################

# @TODO:
# Delete the `input_data` variable from the Streamlit interface.
# input_data = st.text_input("Block Data")

# @TODO:
# Add an input area where you can get a value for `sender` from the user.
sender = st.text_input("Input Donor Information")

# @TODO:
# Add an input area where you can get a value for `receiver` from the user.
receiver = st.text_input("Input Impactor Information")

# @TODO:
# Add an input area where you can get a value for `amount` from the user.
amount = st.text_input("Transaction Amount")

miles = st.number_input("Miles you biked today")
if miles >= 2:
    st.write("great, you sent money")
else:
    st.write("you did not ride enough to earn GAIA coin")

if st.button("Add Block"):
    prev_block = pychain.chain[-1]
    prev_block_hash = prev_block.hash_block()

    # @TODO
    # Update `new_block` so that `Block` consists of an attribute named `record`
    # which is set equal to a `Record` that contains the `sender`, `receiver`,
    # and `amount` values
    new_block = Block(
        # data=input_data,
        record=Record(sender, receiver, amount),
        creator_id=42,
        prev_hash=prev_block_hash
    )

    pychain.add_block(new_block)
    st.balloons()

################################################################################
# Streamlit Code (continues)

st.markdown("## The PyChain Ledger")

pychain_df = pd.DataFrame(pychain.chain)
st.write(pychain_df)

bar_chart = px.bar(x = miles,labels = "miles ridden")
st.sidebar.plotly_chart(bar_chart)

difficulty = st.sidebar.slider("Block Difficulty", 1, 5, 2)
pychain.difficulty = difficulty

st.sidebar.write("# Block Inspector")
selected_block = st.sidebar.selectbox(
    "Which block would you like to see?", pychain.chain
)

st.sidebar.write(selected_block)

if st.button("Validate Chain"):
    st.write(pychain.is_valid())

################################################################################
