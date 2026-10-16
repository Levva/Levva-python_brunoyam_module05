from sqlalchemy import Boolean, String, Integer
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column

class Base(DeclarativeBase):
    pass

class BookORM(Base):
    __tablename__ = "books"

    id: Mapped[int] = mapped_column(Integer, primary_key=True)
    title: Mapped[str] = mapped_column(String(100), nullable=False)
    author: Mapped[str] = mapped_column(String(50))
    year: Mapped[int | None] = mapped_column(Integer, nullable=True)
    genre: Mapped[str] = mapped_column(String(30), default="Не указан")
    is_available: Mapped[bool] = mapped_column(Boolean, default=True)

    def __repr__(self):
        return f"Book(id={self.id}, title={self.title}, author={self.author}, year={self.year}, genre={self.genre}, is_available={self.is_available})"
    