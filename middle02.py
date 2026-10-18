from datetime import datetime

from sqlalchemy import DateTime, Integer, String
from sqlalchemy import insert, func, update, create_engine
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column
from sqlalchemy.orm import Session, sessionmaker

class Base(DeclarativeBase):
    pass

class ReaderORM(Base):
    __tablename__ = "readers"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    name: Mapped[str] = mapped_column(String(100), nullable=False)

    def __repr__(self):
        return f"Reader(id={self.id}, name={self.name})"

class RecordORM(Base):
    __tablename__ = "records"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    book_id: Mapped[int] = mapped_column(Integer, nullable=False)
    reader_id: Mapped[int] = mapped_column(Integer, nullable=False)
    taken_at: Mapped[datetime] = mapped_column(DateTime, default=func.current_timestamp())
    returned_at: Mapped[datetime | None] = mapped_column(DateTime, nullable=True)

    def __repr__(self):
        return f"Record(id={self.id}, book_id={self.book_id}, reader_id={self.reader_id}, taken_at={self.taken_at}, returned_at={self.returned_at})"

def create_user(engine, username: str = "Unknown"):
    SessionLocal = sessionmaker(bind=engine)

    with SessionLocal() as session:
        try:
            stmt = insert(ReaderORM).values(
                name=username
            )

            session.execute(stmt)
            session.commit()
        except Exception:
            session.rollback()
            raise

def create_record(engine, book_id: int, reader_id: int, taken_at: datetime = func.current_timestamp(), returned_at: datetime = None):
    SessionLocal = sessionmaker(bind=engine)

    with SessionLocal() as session:
        try:
            stmt = insert(RecordORM).values(
                book_id=book_id,
                reader_id=reader_id,
                taken_at=taken_at,
                returned_at=returned_at
            )
            session.execute(stmt)
            session.commit()
        except Exception:
            session.rollback()
            raise

def update_record(engine, record_id: int, returned_at: datetime = func.current_timestamp()):
    SessionLocal = sessionmaker(bind=engine)

    with SessionLocal() as session:
        try:
            stmt = update(RecordORM).where(RecordORM.id == record_id).values(
                returned_at=returned_at
            )
            session.execute(stmt)
            session.commit()
        except Exception:
            session.rollback()
            raise

def get_records(session: Session):
    records = session.query(RecordORM).all()
    for record in records:
        print(record)
    return records

def main(engine):
    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()

    create_user(engine, username="John Doe")
    create_record(engine, book_id=5, reader_id=4)
    records = get_records(session)
    update_record(engine, record_id=records[-1].id, returned_at=datetime.now())

if __name__ == "__main__":

    DATABASE_URL = "postgresql+psycopg2://postgres:SomePassword@SomeAddress:SomePort/SomeDatabase"
    engine = create_engine(DATABASE_URL, echo=True)
    Base.metadata.create_all(engine)

    main(engine)